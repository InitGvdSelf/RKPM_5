import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/course_model.dart';
import 'package:rkpm_5/domain/usecases/courses/get_courses_usecase.dart';
import 'package:rkpm_5/domain/usecases/courses/add_course_usecase.dart';
import 'package:rkpm_5/domain/usecases/courses/delete_course_usecase.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final GetCoursesUseCase getCoursesUseCase;
  final AddCourseUseCase addCourseUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;

  CoursesCubit({
    GetCoursesUseCase? getCoursesUseCase,
    AddCourseUseCase? addCourseUseCase,
    DeleteCourseUseCase? deleteCourseUseCase,
  })  : getCoursesUseCase = getCoursesUseCase ?? DI.getCoursesUseCase,
        addCourseUseCase = addCourseUseCase ?? DI.addCourseUseCase,
        deleteCourseUseCase = deleteCourseUseCase ?? DI.deleteCourseUseCase,
        super(CoursesState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final result = await getCoursesUseCase();
    result.fold(
      (_) => emit(state.copyWith(isLoading: false, entries: [])),
      (entries) {
        entries.sort((a, b) => b.startDate.compareTo(a.startDate));
        emit(state.copyWith(isLoading: false, entries: entries));
      },
    );
  }

  Future<void> add(MedCourse entry) async {
    final result = await addCourseUseCase(entry);
    result.fold(
      (_) {},
      (_) => _load(),
    );
  }

  Future<void> delete(String id) async {
    final result = await deleteCourseUseCase(id);
    result.fold(
      (_) {},
      (_) => _load(),
    );
  }
}

