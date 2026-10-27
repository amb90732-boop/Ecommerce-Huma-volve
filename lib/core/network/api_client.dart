import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/constants/api_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final Dio dio;
  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: const {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          final path = options.path.toLowerCase();
          if (path.contains('auth/login') ||
              path.contains('auth/register') ||
              path == 'users' ||
              path.endsWith('/users')) {
            return false;
          }
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );
  }
}

//* "https://api.escuelajs.co/api/v1/auth/login"
//* "https://api.escuelajs.co/api/v1/products?limit=23&offset=23"
