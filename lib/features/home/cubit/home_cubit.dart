import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/home_services.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeServices homeService;
  List<CategoryModel> categories = [];
  int _productsRequestId = 0;

  HomeCubit(this.homeService) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());
    try {
      categories = await homeService.getCategory();
      if (isClosed) return;
      emit(CategoriesSuccess(categories));
      await getProductsForCategory(null);
    } catch (e) {
      if (!isClosed) emit(CategoriesError(e.toString()));
    }
  }

  Future<void> getProductsForCategory(int? categoryId) async {
    final requestId = ++_productsRequestId;
    emit(ProductsLoading());
    try {
      final products = await homeService.getProducts(categoryId);
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
