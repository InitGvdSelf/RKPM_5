import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/data/datasources/diary/dto/diary_entry_dto.dart';

class DiaryLocalDataSource {
  static const _key = 'diary_entries';

  Future<List<DiaryEntryDto>> getDiary() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => DiaryEntryDto.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> saveDiary(List<DiaryEntryDto> entries) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }
}

