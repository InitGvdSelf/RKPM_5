import 'package:rkpm_5/domain/repositories/courses_repository.dart';
import 'package:rkpm_5/core/models/course_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class AddCourseUseCase {
  final CoursesRepository repository;

  AddCourseUseCase(this.repository);

  Future<Either<Failure, void>> call(MedCourse course) {
    return repository.addCourse(course);
  }
}

