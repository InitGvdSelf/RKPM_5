import 'package:rkpm_5/domain/repositories/courses_repository.dart';
import 'package:rkpm_5/core/models/course_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class GetCoursesUseCase {
  final CoursesRepository repository;

  GetCoursesUseCase(this.repository);

  Future<Either<Failure, List<MedCourse>>> call() {
    return repository.getCourses();
  }
}

