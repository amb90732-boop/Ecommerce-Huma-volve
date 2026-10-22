import 'package:dio/dio.dart';

import '../../../core/storage/token_storage.dart';
import 'auth_api_service.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthRepository {
  const AuthRepository({
    required this._apiService,
    required this._tokenStorage,
  });

  final AuthApiService _apiService;
  final TokenStorage _tokenStorage;

  Future<String?> readAccessToken() {
    return _tokenStorage.readAccessToken();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      final token = response['accessToken'];

      if (token is! String || token.isEmpty) {
        throw const AuthException('take sure of the swigger shape..');
      }

      await _tokenStorage.saveAccessToken(token);
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    } on FormatException catch (error) {
      throw AuthException(error.message);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _apiService.register(name: name, email: email, password: password);
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    } on FormatException catch (error) {
      throw AuthException(error.message);
    }
  }

  Future<void> logout() {
    return _tokenStorage.clear();
  }

  String _messageFromDio(DioException error) {
    final data = error.response?.data;

    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }

    if (error.response == null) {
      return 'please try again...';
    }

    // return 'فشل الطلب. راجع البيانات وحاول مرة أخرى.';
    return 'request failed . send data and try again';
  }
}
