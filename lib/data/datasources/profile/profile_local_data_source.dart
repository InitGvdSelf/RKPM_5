import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/data/datasources/profile/dto/user_dto.dart';

class ProfileLocalDataSource {
  static const _key = 'user_profile_v1';

  Future<UserDto?> getProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString(_key);
    if (data == null) return null;
    return UserDto.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserDto profile) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(profile.toJson()));
  }
}

