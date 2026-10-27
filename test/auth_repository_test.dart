import 'package:ecommerce_app_huma_volve/core/storage/token_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTokenStorage implements TokenStorage {
  String? token;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> saveAccessToken(String token) async {
    this.token = token;
  }

  @override
  Future<void> clear() async {
    token = null;
  }
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async => {'access_token': 'api-token'};

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {}
}

void main() {
  test('repository stores the access token returned by the API', () async {
    final tokenStorage = _FakeTokenStorage();
    final repository = AuthRepositoryImpl(
      apiService: _FakeAuthRemoteDataSource(),
      tokenStorage: tokenStorage,
    );

    await repository.login(email: 'test@example.com', password: 'secret');

    expect(tokenStorage.token, 'api-token');
  });
}
