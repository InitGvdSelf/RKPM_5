import 'package:bloc/bloc.dart';
import 'package:rkpm_5/features/meds/domain/visits_repository.dart';
import 'package:rkpm_5/features/meds/models/visit.dart';
import 'visits_state.dart';

class VisitsCubit extends Cubit<VisitsState> {
  final VisitsRepository repo;

  VisitsCubit({required this.repo}) : super(VisitsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final entries = await repo.load();
    entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    emit(state.copyWith(isLoading: false, entries: entries));
  }

  Future<void> add(Visit entry) async {
    final next = [entry, ...state.entries];
    emit(state.copyWith(entries: next));
    await repo.save(next);
  }

  Future<void> delete(String id) async {
    final next = state.entries.where((e) => e.id != id).toList();
    emit(state.copyWith(entries: next));
    await repo.save(next);
  }
}