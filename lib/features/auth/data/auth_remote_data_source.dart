abstract interface class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}
