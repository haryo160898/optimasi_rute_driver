import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exceptions.dart';
import '../domain/auth_session.dart';

class AuthRepository {
  factory AuthRepository({
    required FlutterSecureStorage storage,
    required ApiClient apiClient,
    required AppConfig config,
  }) {
    return AuthRepository._(
      storage: storage,
      apiClient: apiClient,
      config: config,
    );
  }

  AuthRepository._({
    required this._storage,
    required this._apiClient,
    required this._config,
  });

  final FlutterSecureStorage _storage;
  final ApiClient _apiClient;
  final AppConfig _config;

  Future<AuthSession> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      throw const ValidationException('Username dan password wajib diisi.');
    }

    if (_config.mockMode) {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      final session = AuthSession(
        accessToken: 'demo_token_${base64Encode(utf8.encode(username))}',
        userId: 'DRV-001',
        username: username,
      );
      await _storage.write(key: 'access_token', value: session.accessToken);
      await _storage.write(key: 'user_id', value: session.userId);
      await _storage.write(key: 'username', value: session.username);
      return session;
    }

    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/auth/login',
      data: {'username': username, 'password': password},
    );

    final payload = response.data ?? {};
    final session = AuthSession.fromJson(payload);
    await _storage.write(key: 'access_token', value: session.accessToken);
    await _storage.write(key: 'user_id', value: session.userId);
    await _storage.write(key: 'username', value: session.username);
    return session;
  }

  Future<AuthSession?> getStoredSession() async {
    final token = await _storage.read(key: 'access_token');
    final userId = await _storage.read(key: 'user_id');
    final username = await _storage.read(key: 'username');

    if (token == null || token.isEmpty) {
      return null;
    }

    return AuthSession(
      accessToken: token,
      userId: userId ?? 'unknown',
      username: username ?? 'driver',
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'username');
  }
}
