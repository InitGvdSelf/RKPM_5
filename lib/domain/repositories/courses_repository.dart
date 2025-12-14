import 'package:rkpm_5/core/models/course_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';

abstract class CoursesRepository {
  Future<Either<Failure, List<MedCourse>>> getCourses();
  Future<Either<Failure, void>> addCourse(MedCourse course);
  Future<Either<Failure, void>> deleteCourse(String id);
}

