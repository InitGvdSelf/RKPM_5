import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/data/datasources/auth/dto/auth_session_dto.dart';

class AuthLocalDataSource {
  static const _kEmail = 'auth_email';
  static const _kName = 'auth_name';

  Future<AuthSessionDto?> getCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmail);
    if (email == null || email.isEmpty) return null;
    final name = prefs.getString(_kName);
    return AuthSessionDto(email: email, name: name);
  }

  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_kEmail) ?? '').isNotEmpty;
  }

  Future<void> saveSession(AuthSessionDto session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, session.email);
    if (session.name != null) {
      await prefs.setString(_kName, session.name!);
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kEmail);
    await prefs.remove(_kName);
  }
}

