import 'package:ecommerce_app_huma_volve/features/home/models/categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/products_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class CategoriesLoading extends HomeState {}

class CategoriesSuccess extends HomeState {
  final List<CategoryModel> categories;
  CategoriesSuccess(this.categories);
}

class CategoriesError extends HomeState {
  final String errorMessage;
  CategoriesError(this.errorMessage);
}

class ProductsLoading extends HomeState {}

class ProductsSuccess extends HomeState {
  final List<ProductsModel> products;
  ProductsSuccess(this.products);
}

class ProductsError extends HomeState {
  final String errorMessage;
  ProductsError(this.errorMessage);
}
