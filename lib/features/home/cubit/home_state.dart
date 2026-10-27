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
  ProductsSuccess(
    List<Product> products, {
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.loadMoreErrorMessage,
    this.refreshErrorMessage,
  }) : products = List.unmodifiable(products);

  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? loadMoreErrorMessage;
  final String? refreshErrorMessage;

  ProductsSuccess copyWith({
    List<Product>? products,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? loadMoreErrorMessage,
    bool clearLoadMoreError = false,
    String? refreshErrorMessage,
    bool clearRefreshError = false,
  }) {
    return ProductsSuccess(
      products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      loadMoreErrorMessage: clearLoadMoreError
          ? null
          : loadMoreErrorMessage ?? this.loadMoreErrorMessage,
      refreshErrorMessage: clearRefreshError
          ? null
          : refreshErrorMessage ?? this.refreshErrorMessage,
    );
  }
}

class ProductsError extends HomeState {
  final String errorMessage;
  ProductsError(this.errorMessage);
}
