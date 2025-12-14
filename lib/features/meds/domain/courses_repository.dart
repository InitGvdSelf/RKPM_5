import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/med_course.dart';

class CoursesRepository {
  static const _key = 'med_courses';

  Future<List<MedCourse>> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => MedCourse.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> save(List<MedCourse> entries) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}