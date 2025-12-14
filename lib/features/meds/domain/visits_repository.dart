import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/visit.dart';

class VisitsRepository {
  static const _key = 'visits_entries';

  Future<List<Visit>> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => Visit.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> save(List<Visit> entries) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}