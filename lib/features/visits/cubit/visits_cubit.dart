import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/visit_model.dart';
import 'package:rkpm_5/domain/usecases/visits/get_visits_usecase.dart';
import 'package:rkpm_5/domain/usecases/visits/add_visit_usecase.dart';
import 'package:rkpm_5/domain/usecases/visits/delete_visit_usecase.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'visits_state.dart';

class VisitsCubit extends Cubit<VisitsState> {
  final GetVisitsUseCase getVisitsUseCase;
  final AddVisitUseCase addVisitUseCase;
  final DeleteVisitUseCase deleteVisitUseCase;

  VisitsCubit({
    GetVisitsUseCase? getVisitsUseCase,
    AddVisitUseCase? addVisitUseCase,
    DeleteVisitUseCase? deleteVisitUseCase,
  })  : getVisitsUseCase = getVisitsUseCase ?? DI.getVisitsUseCase,
        addVisitUseCase = addVisitUseCase ?? DI.addVisitUseCase,
        deleteVisitUseCase = deleteVisitUseCase ?? DI.deleteVisitUseCase,
        super(VisitsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final result = await getVisitsUseCase();
    result.fold(
      (_) => emit(state.copyWith(isLoading: false, entries: [])),
      (entries) {
        entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        emit(state.copyWith(isLoading: false, entries: entries));
      },
    );
  }

  Future<void> add(Visit entry) async {
    final result = await addVisitUseCase(entry);
    result.fold(
      (_) {},
      (_) => _load(),
    );
  }

  Future<void> delete(String id) async {
    final result = await deleteVisitUseCase(id);
    result.fold(
      (_) {},
      (_) => _load(),
    );
  }
}

