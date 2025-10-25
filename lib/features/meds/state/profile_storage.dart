import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/profile.dart';

class ProfileStorage {
  static const _key = 'user_profile_v1';

  static Future<void> save(Profile p) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, p.toJsonString());
  }

  static Future<Profile?> load() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString(_key);
    if (data == null) return null;
    return Profile.fromJsonString(data);
  }
}