import 'package:ecommerce_app_huma_volve/features/auth/login/screens/login_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/screens/sign_up_screen.dart';
import 'package:ecommerce_app_huma_volve/features/auth/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  String? registeredName;

  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    registeredName = name;
  }

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('Sign Up opens the create account screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthController(_FakeAuthRepository()),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sign up submits to AuthController before returning to login', (
    WidgetTester tester,
  ) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthController(repository),
        child: const MaterialApp(home: SignUpScreen()),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(repository.registeredName, 'Test User');
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
