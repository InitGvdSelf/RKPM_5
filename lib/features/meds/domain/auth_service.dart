import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rkpm_5/features/meds/models/user_account.dart';

class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kEmail = 'auth_email';
  static const _kName = 'auth_name';

  UserAccount? _current;
  UserAccount? get current => _current;
  bool get isLoggedIn => _current != null;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmail);
    final name = prefs.getString(_kName);

    if (email != null && email.isNotEmpty) {
      _current = UserAccount(email: email, name: name);
    } else {
      _current = null;
    }

    notifyListeners();
  }

  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_kEmail) ?? '').isNotEmpty;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email);
    _current = UserAccount(email: email);
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kName, name);
    _current = UserAccount(email: email, name: name);
    notifyListeners();
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kEmail);
    await prefs.remove(_kName);
    _current = null;
    notifyListeners();
  }
}