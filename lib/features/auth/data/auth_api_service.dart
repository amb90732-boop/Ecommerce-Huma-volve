import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/storage/token_storage.dart';



class AuthApiService {
  AuthApiService({
    required String baseUrl,
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: const {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readAccessToken();

          //* That already found..
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio _dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _post(
      '/auth/login',
      {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _post(
      '/auth/register',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post<dynamic>(path, data: data);
    final responseData = response.data;


    return Map<String, dynamic>.from(responseData);
  }
}