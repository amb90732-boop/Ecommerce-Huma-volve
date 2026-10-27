import 'package:dio/dio.dart';

import '../../../core/storage/token_storage.dart';
import '../domain/auth_exception.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this._apiService,
    required this._tokenStorage,
  });

  final AuthRemoteDataSource _apiService;
  final TokenStorage _tokenStorage;

  @override
  Future<String?> readAccessToken() {
    return _tokenStorage.readAccessToken();
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      final token = response['access_token'] ?? response['accessToken'];

      if (token is! String || token.isEmpty) {
        throw const AuthException(
          'The server did not return a valid access token.',
        );
      }

      await _tokenStorage.saveAccessToken(token);
    } on DioException catch (error) {
      throw AuthException(_messageFromDio(error));
    } on FormatException catch (error) {
      throw AuthException(error.message);
    }
  }

  @override
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

  @override
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
