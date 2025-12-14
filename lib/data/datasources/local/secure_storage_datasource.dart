import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDataSource {
  SecureStorageDataSource({
    FlutterSecureStorage? storage,
  }) : _storage = storage ??
      const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      );

  final FlutterSecureStorage _storage;

  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyPinCode = 'pin_code';
  static const String keyBiometricEnabled = 'biometric_enabled';

  // Access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: keyAccessToken);
  }

  // Refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: keyRefreshToken);
  }

  // UserId
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: keyUserId, value: userId);
  }

  Future<String?> getUserId() async {
    return _storage.read(key: keyUserId);
  }

  // PIN
  Future<void> savePinCode(String pin) async {
    await _storage.write(key: keyPinCode, value: pin);
  }

  Future<bool> verifyPinCode(String pin) async {
    final saved = await _storage.read(key: keyPinCode);
    return saved != null && saved == pin;
  }

  // Biometrics toggle
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: keyBiometricEnabled,
      value: enabled.toString(), // "true"/"false"
    );
  }

  Future<bool> isBiometricEnabled() async {
    final v = await _storage.read(key: keyBiometricEnabled);
    return v == 'true';
  }

  // Tokens helpers
  Future<bool> hasTokens() async {
    final a = await getAccessToken();
    final r = await getRefreshToken();
    return (a != null && a.isNotEmpty) && (r != null && r.isNotEmpty);
  }

  Future<void> clearAllTokens() async {
    await _storage.delete(key: keyAccessToken);
    await _storage.delete(key: keyRefreshToken);
  }

  Future<Map<String, String>> getAllValues() async {
    final all = await _storage.readAll();
    return all.map((k, v) => MapEntry(k, v));
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}