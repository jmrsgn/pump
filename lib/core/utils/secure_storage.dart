import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/entity/user.dart';

class SecureStorage {
  // Singleton instance
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  SecureStorage._internal();

  static const _tokenKey = 'jwt_token';
  static const _currentLoggedInUser = 'current_logged_in_user';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveCurrentLoggedInUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _currentLoggedInUser, value: userJson);
  }

  Future<User?> getCurrentLoggedInUser() async {
    final userJson = await _storage.read(key: _currentLoggedInUser);
    if (userJson == null) {
      return null;
    }

    final Map<String, dynamic> jsonMap = jsonDecode(userJson);
    return User.fromJson(jsonMap);
  }

  Future<void> deleteCurrentLoggedInUser() async {
    await _storage.delete(key: _currentLoggedInUser);
  }
}
