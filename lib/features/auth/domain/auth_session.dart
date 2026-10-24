class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.userId,
    required this.username,
  });

  final String accessToken;
  final String userId;
  final String username;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken:
          json['accessToken'] as String? ?? json['token'] as String? ?? '',
      userId: json['userId'] as String? ?? json['id'] as String? ?? 'driver_01',
      username: json['username'] as String? ?? 'driver',
    );
  }
}
