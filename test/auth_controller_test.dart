import 'package:ecommerce_app_huma_volve/features/auth/domain/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/state/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  String? token;
  String? registeredName;

  @override
  Future<String?> readAccessToken() async => token;

  @override
  Future<void> login({required String email, required String password}) async {
    token = 'test-token';
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    registeredName = name;
  }

  @override
  Future<void> logout() async {
    token = null;
  }
}

void main() {
  test('login updates the authentication state and session token', () async {
    final repository = _FakeAuthRepository();
    final controller = AuthController(repository);

    expect(
      await controller.login(email: 'a@b.com', password: 'secret'),
      isTrue,
    );
    expect(controller.status, AuthState.signedIn);
    expect(await repository.readAccessToken(), 'test-token');

    await controller.logout();
    expect(controller.status, AuthState.signedOut);
    expect(await repository.readAccessToken(), isNull);
    controller.dispose();
  });

  test('registration delegates credentials to the repository', () async {
    final repository = _FakeAuthRepository();
    final controller = AuthController(repository);

    expect(
      await controller.register(
        name: 'Test User',
        email: 'test@example.com',
        password: 'secret',
      ),
      isTrue,
    );
    expect(repository.registeredName, 'Test User');
    expect(controller.status, AuthState.signedOut);
    controller.dispose();
  });
}
