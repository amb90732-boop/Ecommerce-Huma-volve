import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  static const int pageSize = 20;

  final HomeRepository homeRepository;
  List<Category> _categories = const [];
  List<Category> get categories => _categories;
  int _productsRequestId = 0;
  int _productsOffset = 0;
  int? _selectedCategoryId;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  HomeCubit(this.homeRepository) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());
    try {
      _categories = List.unmodifiable(await homeRepository.getCategories());
      if (isClosed) return;
      emit(CategoriesSuccess(_categories));
      await getProductsForCategory(null);
    } catch (e) {
      if (!isClosed) emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProductsForCategory(int? categoryId) async {
    final requestId = ++_productsRequestId;
    _selectedCategoryId = categoryId;
    _productsOffset = 0;
    _hasMore = true;
    _isLoadingMore = false;
    emit(ProductsLoading());
    await _loadFirstProductsPage(categoryId, requestId);
  }

  Future<void> _loadFirstProductsPage(int? categoryId, int requestId) async {
    try {
      final products = await homeRepository.getProducts(
        categoryId: categoryId,
        limit: pageSize,
        offset: 0,
      );
      if (!isClosed && requestId == _productsRequestId) {
        _productsOffset = products.length;
        _hasMore = products.length == pageSize;
        emit(ProductsSuccess(products, hasMore: _hasMore));
      }
    } catch (e) {
      if (!isClosed && requestId == _productsRequestId) {
        emit(ProductsError(e.toString()));
      }
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is! ProductsSuccess ||
        !_hasMore ||
        _isLoadingMore ||
        currentState.isRefreshing ||
        currentState.refreshErrorMessage != null) {
      return;
    }

    final requestId = _productsRequestId;
    _isLoadingMore = true;
    emit(currentState.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final products = await homeRepository.getProducts(
        categoryId: _selectedCategoryId,
        limit: pageSize,
        offset: _productsOffset,
      );
      if (!isClosed && requestId == _productsRequestId) {
        _productsOffset += products.length;
        _hasMore = products.length == pageSize;
        emit(
          ProductsSuccess([
            ...currentState.products,
            ...products,
          ], hasMore: _hasMore),
        );
      }
    } catch (e) {
      if (!isClosed && requestId == _productsRequestId) {
        emit(
          currentState.copyWith(
            isLoadingMore: false,
            loadMoreErrorMessage: e.toString(),
          ),
        );
      }
    } finally {
      if (requestId == _productsRequestId) {
        _isLoadingMore = false;
      }
    }
  }

  Future<void> refreshProducts() async {
    final currentState = state;
    if (currentState is! ProductsSuccess) {
      await getProductsForCategory(_selectedCategoryId);
      return;
    }

    final requestId = ++_productsRequestId;
    _isLoadingMore = false;
    emit(
      currentState.copyWith(
        isLoadingMore: false,
        isRefreshing: true,
        clearLoadMoreError: true,
        clearRefreshError: true,
      ),
    );

    try {
      final products = await homeRepository.getProducts(
        categoryId: _selectedCategoryId,
        limit: pageSize,
        offset: 0,
      );
      if (!isClosed && requestId == _productsRequestId) {
        _productsOffset = products.length;
        _hasMore = products.length == pageSize;
        emit(ProductsSuccess(products, hasMore: _hasMore));
      }
    } catch (e) {
      if (!isClosed && requestId == _productsRequestId) {
        emit(
          currentState.copyWith(
            isLoadingMore: false,
            isRefreshing: false,
            refreshErrorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
