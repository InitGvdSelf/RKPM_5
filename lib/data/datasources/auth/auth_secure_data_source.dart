import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage data source for authentication tokens.
/// Uses Flutter Secure Storage with encrypted SharedPreferences on Android
/// and Keychain on iOS for secure token storage.
class AuthSecureDataSource {
  static final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: const IOSOptions(),
  );
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUserId = 'user_id';
  /// Save authentication tokens to secure storage
  Future<void> saveTokens({
    required String access,
    required String refresh,
    String? userId,
  }) async {
    await _storage.write(key: _kAccessToken, value: access);
    await _storage.write(key: _kRefreshToken, value: refresh);
    if (userId != null) {
      await _storage.write(key: _kUserId, value: userId);
    }
  }
  /// Get access token from secure storage
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _kAccessToken);
  }
  /// Get refresh token from secure storage
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _kRefreshToken);
  }
  /// Get user ID from secure storage
  Future<String?> getUserId() async {
    return await _storage.read(key: _kUserId);
  }
  /// Check if tokens exist in secure storage
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
  /// Clear all tokens from secure storage
  Future<void> clearTokens() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
    await _storage.delete(key: _kUserId);
  }
}

