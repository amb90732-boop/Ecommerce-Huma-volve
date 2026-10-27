// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ecommerce_app_huma_volve/features/auth/domain/auth_repository.dart';
import 'package:ecommerce_app_huma_volve/features/auth/state/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app_huma_volve/main.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.accessToken});

  final String? accessToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {}
}

void main() {
  testWidgets('app shows the login page after the splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthController(_FakeAuthRepository())..checkSession(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Huma-volve'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saved session still shows splash, login, and sign up', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            AuthController(_FakeAuthRepository(accessToken: 'saved-token')),
        child: const MyApp(),
      ),
    );

    expect(find.text('Huma-volve'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
