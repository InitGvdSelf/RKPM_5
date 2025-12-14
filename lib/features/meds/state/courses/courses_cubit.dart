import 'package:bloc/bloc.dart';
import 'package:rkpm_5/features/meds/domain/courses_repository.dart';
import 'package:rkpm_5/features/meds/domain/meds_state.dart';
import 'package:rkpm_5/features/meds/models/med_course.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CoursesRepository repo;
  final MedsState medsState;

  CoursesCubit({required this.repo, required this.medsState})
      : super(CoursesState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final entries = await repo.load();
    entries.sort((a, b) => b.startDate.compareTo(a.startDate));
    emit(state.copyWith(isLoading: false, entries: entries));
  }

  Future<void> add(MedCourse entry) async {
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