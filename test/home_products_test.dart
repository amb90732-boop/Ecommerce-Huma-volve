import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/home/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/home_services.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/categories_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/models/products_model.dart';
import 'package:ecommerce_app_huma_volve/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeServices extends HomeServices {
  _FakeHomeServices() : super(ApiClient());

  final requestedCategoryIds = <int?>[];

  @override
  Future<List<CategoryModel>> getCategory() async => [
    CategoryModel(id: 1, name: 'Shoes'),
    CategoryModel(id: 2, name: 'Clothing'),
  ];

  @override
  Future<List<ProductsModel>> getProducts(int? categoryId) async {
    requestedCategoryIds.add(categoryId);
    final title = switch (categoryId) {
      1 => 'Shoes product',
      2 => 'Clothing product',
      _ => 'All products',
    };
    return [
      ProductsModel(id: categoryId, title: title, price: 25, images: const []),
    ];
  }
}

void main() {
  testWidgets('selecting a category shows only its products', (tester) async {
    final services = _FakeHomeServices();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => HomeCubit(services),
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('All products'), findsOneWidget);

    await tester.tap(find.text('Shoes'));
    await tester.pumpAndSettle();
    expect(find.text('Shoes product'), findsOneWidget);
    expect(find.text('Clothing product'), findsNothing);

    await tester.tap(find.text('Clothing'));
    await tester.pumpAndSettle();
    expect(find.text('Clothing product'), findsOneWidget);
    expect(find.text('Shoes product'), findsNothing);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('All products'), findsOneWidget);
    expect(services.requestedCategoryIds, [null, 1, 2, null]);
    expect(tester.takeException(), isNull);
  });
}
