import 'package:ecommerce_app_huma_volve/features/home/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/home_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepository {
  final requestedCategoryIds = <int?>[];

  @override
  Future<List<Category>> getCategories() async => [
    const Category(id: 1, name: 'Shoes'),
    const Category(id: 2, name: 'Clothing'),
  ];

  @override
  Future<List<Product>> getProducts({int? categoryId}) async {
    requestedCategoryIds.add(categoryId);
    final title = switch (categoryId) {
      1 => 'Shoes product',
      2 => 'Clothing product',
      _ => 'All products',
    };
    return [
      Product(
        id: categoryId ?? 0,
        title: title,
        price: 25,
        description: '',
        category: null,
        images: const [],
      ),
    ];
  }
}

void main() {
  testWidgets('selecting a category shows only its products', (tester) async {
    final repository = _FakeHomeRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => HomeCubit(repository),
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
    expect(repository.requestedCategoryIds, [null, 1, 2, null]);
    expect(tester.takeException(), isNull);
  });
}
