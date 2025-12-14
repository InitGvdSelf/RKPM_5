import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/domain/usecases/meds/get_meds_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/upsert_med_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/delete_med_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/restore_med_usecase.dart';
import 'meds_state.dart';

class MedsCubit extends Cubit<MedsState> {
  final GetMedsUseCase getMedsUseCase;
  final UpsertMedUseCase upsertMedUseCase;
  final DeleteMedUseCase deleteMedUseCase;
  final RestoreMedUseCase restoreMedUseCase;

  MedsCubit({
    GetMedsUseCase? getMedsUseCase,
    UpsertMedUseCase? upsertMedUseCase,
    DeleteMedUseCase? deleteMedUseCase,
    RestoreMedUseCase? restoreMedUseCase,
  })  : getMedsUseCase = getMedsUseCase ?? DI.getMedsUseCase,
        upsertMedUseCase = upsertMedUseCase ?? DI.upsertMedUseCase,
        deleteMedUseCase = deleteMedUseCase ?? DI.deleteMedUseCase,
        restoreMedUseCase = restoreMedUseCase ?? DI.restoreMedUseCase,
        super(MedsState.initial()) {
    loadMeds();
  }

  Future<void> loadMeds() async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await getMedsUseCase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (meds) => emit(state.copyWith(medicines: meds, isLoading: false)),
    );
  }

  Future<void> addMedicine(Medicine medicine) async {
    final result = await upsertMedUseCase(medicine);
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) => loadMeds(),
    );
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final result = await upsertMedUseCase(medicine);
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) => loadMeds(),
    );
  }

  Future<Medicine?> deleteMedicine(String id) async {
    final result = await deleteMedUseCase(id);
    return result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
        return null;
      },
      (removed) {
        loadMeds();
        return removed;
      },
    );
  }

  Future<void> restoreMedicine(Medicine medicine) async {
    final result = await restoreMedUseCase(medicine);
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) => loadMeds(),
    );
  }
}

