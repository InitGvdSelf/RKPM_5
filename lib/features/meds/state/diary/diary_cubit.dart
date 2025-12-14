import 'package:bloc/bloc.dart';
import 'package:rkpm_5/features/meds/domain/diary_repository.dart';
import 'package:rkpm_5/features/meds/models/diary_entry.dart';
import 'diary_state.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final DiaryRepository repo;

  DiaryCubit({required this.repo}) : super(DiaryState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final entries = await repo.load();
    entries.sort((a, b) => b.date.compareTo(a.date));
    emit(state.copyWith(isLoading: false, entries: entries));
  }

  Future<void> add(DiaryEntry entry) async {
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