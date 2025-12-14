class AuthData {
  const AuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final String userId;
  final Duration? expiresIn;
}