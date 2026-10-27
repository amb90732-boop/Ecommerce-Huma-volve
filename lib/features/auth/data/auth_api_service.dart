import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

import 'auth_remote_data_source.dart';

class AuthApiService implements AuthRemoteDataSource {
  const AuthApiService(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _post(ApiEndpoints.loginEndpoint, {
      'email': email,
      'password': password,
    });
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _post(ApiEndpoints.signupEndpoint, {
      'name': name,
      'email': email,
      'password': password,
      'avatar': 'https://i.imgur.com/LDOO4Qs.jpg',
    });
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.post<dynamic>(path, data: data);
    final responseData = response.data;

    if (responseData is! Map) {
      throw const FormatException('The server returned an invalid response.');
    }

    return Map<String, dynamic>.from(responseData);
  }
}
