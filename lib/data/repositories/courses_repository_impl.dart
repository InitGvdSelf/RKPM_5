import 'package:rkpm_5/domain/repositories/courses_repository.dart';
import 'package:rkpm_5/core/models/course_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/courses/courses_local_data_source.dart';
import 'package:rkpm_5/data/datasources/courses/mappers/course_mapper.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesLocalDataSource dataSource;

  CoursesRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<MedCourse>>> getCourses() async {
    try {
      final dtos = await dataSource.getCourses();
      return Either.right(CourseMapper.toDomainList(dtos));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCourse(MedCourse course) async {
    try {
      final dtos = await dataSource.getCourses();
      final courses = CourseMapper.toDomainList(dtos);
      courses.add(course);
      await dataSource.saveCourses(CourseMapper.toDtoList(courses));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(String id) async {
    try {
      final dtos = await dataSource.getCourses();
      final courses = CourseMapper.toDomainList(dtos);
      courses.removeWhere((c) => c.id == id);
      await dataSource.saveCourses(CourseMapper.toDtoList(courses));
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

