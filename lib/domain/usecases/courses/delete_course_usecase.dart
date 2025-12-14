import 'package:rkpm_5/domain/repositories/courses_repository.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

class DeleteCourseUseCase {
  final CoursesRepository repository;

  DeleteCourseUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteCourse(id);
  }
}

