import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/diary_entry.dart';

class DiaryRepository {
  static const _key = 'diary_entries';

  Future<List<DiaryEntry>> load() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => DiaryEntry.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> save(List<DiaryEntry> entries) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}