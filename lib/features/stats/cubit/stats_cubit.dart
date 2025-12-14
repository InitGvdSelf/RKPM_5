import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/domain/usecases/meds/get_meds_usecase.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final GetMedsUseCase getMedsUseCase;

  StatsCubit({
    GetMedsUseCase? getMedsUseCase,
  })  : getMedsUseCase = getMedsUseCase ?? DI.getMedsUseCase,
        super(StatsState.initial()) {
    recalculate();
  }

  Future<void> recalculate() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final medsResult = await getMedsUseCase();
      final dosesResult = await DI.medsRepository.getDoses();

      return medsResult.fold(
        (failure) => emit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
          ),
        ),
        (meds) => dosesResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              error: failure.message,
            ),
          ),
          (doses) {
            final totalMeds = meds.length;
            final totalDoses = doses.length;

            final taken = doses.where((d) => d.status == DoseStatus.taken).length;
            final skipped = doses.where((d) => d.status == DoseStatus.skipped).length;
            final pending = doses.where((d) => d.status == DoseStatus.pending).length;

            final adherence = totalDoses == 0 ? 0.0 : taken / totalDoses;

            emit(
              state.copyWith(
                isLoading: false,
                totalMeds: totalMeds,
                totalDoses: totalDoses,
                takenDoses: taken,
                skippedDoses: skipped,
                pendingDoses: pending,
                adherence: adherence,
              ),
            );
          },
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Не удалось пересчитать статистику',
        ),
      );
    }
  }
}

