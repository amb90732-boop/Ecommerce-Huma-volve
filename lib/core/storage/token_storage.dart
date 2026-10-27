import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class TokenStorage {
  Future<String?> readAccessToken();

  Future<void> saveAccessToken(String token);

  Future<void> clear();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';

  @override
  Future<String?> readAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> clear() {
    return _storage.delete(key: _accessTokenKey);
  }
}
