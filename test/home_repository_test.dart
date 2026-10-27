import 'package:ecommerce_app_huma_volve/features/home/data/home_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/home_repository_impl.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async => [
    const CategoryModel(id: 5, name: 'Shoes'),
  ];

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) async => [
    ProductModel(
      id: 8,
      title: 'Sneakers',
      price: 99,
      description: 'Comfortable shoes',
      images: const ['image.jpg'],
      category: const CategoryModel(id: 5, name: 'Shoes'),
    ),
  ];
}

void main() {
  test('repository maps API models to domain entities', () async {
    final repository = HomeRepositoryImpl(_FakeHomeRemoteDataSource());

    final categories = await repository.getCategories();
    final products = await repository.getProducts(categoryId: 5);

    expect(categories.single, isA<Category>());
    expect(categories.single.name, 'Shoes');
    expect(products.single, isA<Product>());
    expect(products.single.title, 'Sneakers');
    expect(products.single.category?.id, 5);
  });
}
