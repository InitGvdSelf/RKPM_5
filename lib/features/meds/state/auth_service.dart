import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/user_account.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kEmail = 'auth_email';
  static const _kName = 'auth_name';

  Future<UserAccount?> currentUser() async {
    final p = await SharedPreferences.getInstance();
    final email = p.getString(_kEmail);
    if (email == null || email.isEmpty) return null;
    final name = p.getString(_kName);
    return UserAccount(email: email, name: name);
  }

  Future<bool> isSignedIn() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString(_kEmail) ?? '').isNotEmpty;
  }

  Future<void> signIn({required String email, required String password}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kEmail, email);
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kEmail, email);
    await p.setString(_kName, name);
  }

  Future<void> signOut() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kEmail);
    await p.remove(_kName);
  }
}