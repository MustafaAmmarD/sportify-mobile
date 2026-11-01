import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  /// Caches the signed-in user so the session can be restored on startup.
  Future<void> cacheUser(User user);

  /// Returns the cached user, or null if none / unreadable.
  Future<User?> getUser();

  /// Removes token and cached user.
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this.secureStorage);

  final FlutterSecureStorage secureStorage;
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  @override
  Future<void> cacheToken(String token) {
    return secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() {
    return secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() {
    return secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> cacheUser(User user) {
    return secureStorage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  @override
  Future<User?> getUser() async {
    final raw = await secureStorage.read(key: _userKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      return User.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _userKey);
  }
}
