import '../domain/entities/category.dart';
import '../domain/entities/product.dart';
import '../domain/home_repository.dart';
import 'home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Category>> getCategories() async {
    final categories = await _remoteDataSource.getCategories();
    return categories.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<List<Product>> getProducts({
    int? categoryId,
    required int limit,
    required int offset,
  }) async {
    final products = await _remoteDataSource.getProducts(
      categoryId: categoryId,
      limit: limit,
      offset: offset,
    );
    return products.map((model) => model.toEntity()).toList(growable: false);
  }
}
