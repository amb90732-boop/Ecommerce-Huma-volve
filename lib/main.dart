import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'core/theme.dart';
import 'features/auth/data/auth_api_service.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/state/auth_state.dart';
import 'features/home/data/home_repository_impl.dart';
import 'features/home/data/home_remote_data_source.dart';
import 'features/home/domain/home_repository.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  final apiClient = ApiClient();
  final tokenStorage = SecureTokenStorage();
  final authRepository = AuthRepositoryImpl(
    apiService: AuthApiService(apiClient),
    tokenStorage: tokenStorage,
  );
  final homeRepository = HomeRepositoryImpl(HomeApiDataSource(apiClient));

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        Provider<HomeRepository>.value(value: homeRepository),
        ChangeNotifierProvider(
          create: (context) =>
              AuthController(context.read<AuthRepository>())..checkSession(),
        ),
      ],
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
