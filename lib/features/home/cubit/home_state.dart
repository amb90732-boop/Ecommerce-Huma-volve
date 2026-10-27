import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  CategoriesSuccess(List<Category> categories)
    : categories = List.unmodifiable(categories);

  final List<Category> categories;
}

class CategoriesError extends HomeState {
  final String errorMessage;
  CategoriesError(this.errorMessage);
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  ProductsSuccess(List<Product> products)
    : products = List.unmodifiable(products);

  final List<Product> products;
}

class ProductsError extends HomeState {
  final String errorMessage;
  ProductsError(this.errorMessage);
}
