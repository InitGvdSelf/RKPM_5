import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/profile.dart';

class ProfileStorage {
  static const _key = 'profile_json';

  static Future<Profile?> load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_key);
    if (s == null) return null;
    final j = jsonDecode(s) as Map<String, dynamic>;
    return Profile.fromJson(j);
  }

  static Future<void> save(Profile p) async {
    final sp = await SharedPreferences.getInstance();
    final s = jsonEncode(p.toJson());
    await sp.setString(_key, s);
  }
}