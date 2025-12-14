import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/data/datasources/courses/dto/course_dto.dart';

class CoursesLocalDataSource {
  static const _key = 'med_courses';

  Future<List<CourseDto>> getCourses() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => CourseDto.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> saveCourses(List<CourseDto> entries) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}

