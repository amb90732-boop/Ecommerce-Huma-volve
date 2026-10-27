import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/products_model.dart';

class HomeServices {
  final ApiClient apiClient;
  HomeServices(this.apiClient);

  Future<List<CategoryModel>> getCategory() async {
    final response = await apiClient.dio.get(ApiEndpoints.categoriesEndpoint);
    final List jsonDate = response.data;
    final List<CategoryModel> categories = jsonDate
        .map((e) => CategoryModel.fromJson(e))
        .toList();

    return categories;
  }

  Future<List<ProductsModel>> getProducts(int? categoryId) async {
    final endpoint = categoryId == null
        ? ApiEndpoints.productsEndpoint
        : "${ApiEndpoints.categoriesEndpoint}/$categoryId/${ApiEndpoints.productsEndpoint}";
    final response = await apiClient.dio.get(endpoint);

    final List jsonData = response.data;
    final List<ProductsModel> products = jsonData
        .map((e) => ProductsModel.fromJson(e))
        .toList();

    return products;
  }
}
