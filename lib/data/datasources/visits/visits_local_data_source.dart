import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/data/datasources/visits/dto/visit_dto.dart';

class VisitsLocalDataSource {
  static const _key = 'visits_entries';

  Future<List<VisitDto>> getVisits() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => VisitDto.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> saveVisits(List<VisitDto> entries) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}

