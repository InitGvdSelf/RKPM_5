import '../../core/models/auth_data.dart';
import '../../data/datasources/local/secure_storage_datasource.dart';

class AuthUseCase {
  AuthUseCase(this._ds);

  final SecureStorageDataSource _ds;

  Future<void> saveAuthData(AuthData data) async {
    await _ds.saveAccessToken(data.accessToken);
    await _ds.saveRefreshToken(data.refreshToken);
    await _ds.saveUserId(data.userId);
  }

  Future<AuthData?> getAuthData() async {
    final has = await _ds.hasTokens();
    if (!has) return null;

    final access = await _ds.getAccessToken();
    final refresh = await _ds.getRefreshToken();
    final userId = await _ds.getUserId();

    if (access == null || refresh == null || userId == null) return null;

    return AuthData(
      accessToken: access,
      refreshToken: refresh,
      userId: userId,
    );
  }

  Future<bool> isAuthenticated() async {
    return _ds.hasTokens();
  }

  Future<void> updateAccessToken(String newToken) async {
    await _ds.saveAccessToken(newToken);
  }

  Future<void> logout() async {
    await _ds.clearAllTokens();
  }
}