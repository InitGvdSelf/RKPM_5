import 'package:rkpm_5/core/models/course_model.dart';
import 'package:rkpm_5/data/datasources/courses/dto/course_dto.dart';

class CourseMapper {
  static MedCourse toDomain(CourseDto dto) {
    return MedCourse.fromJson(dto.toJson());
  }

  static CourseDto toDto(MedCourse course) {
    return CourseDto.fromJson(course.toJson());
  }

  static List<MedCourse> toDomainList(List<CourseDto> dtos) {
    return dtos.map((dto) => toDomain(dto)).toList();
  }

  static List<CourseDto> toDtoList(List<MedCourse> courses) {
    return courses.map((course) => toDto(course)).toList();
  }
}

