import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  List<Category> _categories = const [];
  List<Category> get categories => _categories;
  int _productsRequestId = 0;

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
    emit(ProductsLoading());
    try {
      final products = await homeRepository.getProducts(categoryId: categoryId);
      if (!isClosed && requestId == _productsRequestId) {
        emit(ProductsSuccess(products));
      }
    } catch (e) {
      if (!isClosed && requestId == _productsRequestId) {
        emit(ProductsError(e.toString()));
      }
    }
  }
}
