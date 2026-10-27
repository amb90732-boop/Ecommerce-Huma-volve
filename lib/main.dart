import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/storage/token_storage.dart';
import 'core/theme.dart';
import 'features/auth/data/auth_api_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/state/auth_state.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  final tokenStorage = TokenStorage();

  final authApiService = AuthApiService(
    baseUrl: 'https://api.escuelajs.co/api/v1/auth/login',
    tokenStorage: tokenStorage,
  );

  final authRepository = AuthRepository(
    apiService: authApiService,
    tokenStorage: tokenStorage,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthController(authRepository)..checkSession(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
