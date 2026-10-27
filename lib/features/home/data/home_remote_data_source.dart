import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';

import 'models/category_model.dart';
import 'models/product_model.dart';

abstract interface class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    required int limit,
    required int offset,
  });
}

class HomeApiDataSource implements HomeRemoteDataSource {
  const HomeApiDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final data = response.data;
    if (data is! List) {
      throw const FormatException('Invalid categories response.');
    }

    return data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid category item response.');
          }
          return CategoryModel.fromJson(item);
        })
        .toList(growable: false);
  }

  @override
  Future<List<ProductModel>> getProducts({
    int? categoryId,
    required int limit,
    required int offset,
  }) async {
    final endpoint = categoryId == null
        ? ApiEndpoints.productsEndpoint
        : "${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}";
    final response = await _apiClient.dio.get(
      endpoint,
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final data = response.data;
    if (data is! List) {
      throw const FormatException('Invalid products response.');
    }

    return data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid product item response.');
          }
          return ProductModel.fromJson(item);
        })
        .toList(growable: false);
  }
}
