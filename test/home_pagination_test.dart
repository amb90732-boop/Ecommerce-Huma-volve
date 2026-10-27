import 'dart:async';

import 'package:ecommerce_app_huma_volve/features/home/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/cubit/home_state.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/category.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _PaginatedHomeRepository implements HomeRepository {
  final requests = <({int? categoryId, int limit, int offset})>[];
  bool failNextPage = false;
  bool failNextFirstPage = false;
  bool changeProductsOnRefresh = false;
  Completer<void>? nextPageCompleter;

  @override
  Future<List<Category>> getCategories() async => const [];

  @override
  Future<List<Product>> getProducts({
    int? categoryId,
    required int limit,
    required int offset,
  }) async {
    requests.add((categoryId: categoryId, limit: limit, offset: offset));
    if (offset == 0 && failNextFirstPage) {
      failNextFirstPage = false;
      throw StateError('Refresh failed.');
    }
    if (offset > 0 && failNextPage) {
      failNextPage = false;
      throw StateError('Page request failed.');
    }
    if (offset > 0 && nextPageCompleter != null) {
      await nextPageCompleter!.future;
    }

    final count = offset == 0 ? limit : 1;
    final idOffset = changeProductsOnRefresh && offset == 0 ? 100 : 0;
    return List.generate(
      count,
      (index) => Product(
        id: idOffset + offset + index + 1,
        title: 'Product ${idOffset + offset + index + 1}',
        price: 10,
        description: '',
        category: null,
        images: const [],
      ),
    );
  }
}

void main() {
  test('appends pages and stops when the API returns a short page', () async {
    final repository = _PaginatedHomeRepository();
    final cubit = HomeCubit(repository);

    await cubit.getProductsForCategory(null);
    expect((cubit.state as ProductsSuccess).products, hasLength(20));
    expect((cubit.state as ProductsSuccess).hasMore, isTrue);

    await cubit.loadMoreProducts();
    expect((cubit.state as ProductsSuccess).products, hasLength(21));
    expect((cubit.state as ProductsSuccess).hasMore, isFalse);

    await cubit.loadMoreProducts();
    expect(repository.requests.map((request) => request.offset), [0, 20]);

    await cubit.close();
  });

  test('retains products and retries a failed next-page request', () async {
    final repository = _PaginatedHomeRepository()..failNextPage = true;
    final cubit = HomeCubit(repository);

    await cubit.getProductsForCategory(null);
    await cubit.loadMoreProducts();

    var state = cubit.state as ProductsSuccess;
    expect(state.products, hasLength(20));
    expect(state.loadMoreErrorMessage, contains('Page request failed.'));

    await cubit.loadMoreProducts();
    state = cubit.state as ProductsSuccess;
    expect(state.products, hasLength(21));
    expect(state.loadMoreErrorMessage, isNull);
    expect(repository.requests.map((request) => request.offset), [0, 20, 20]);

    await cubit.close();
  });

  test('does not make concurrent next-page requests', () async {
    final repository = _PaginatedHomeRepository()
      ..nextPageCompleter = Completer<void>();
    final cubit = HomeCubit(repository);

    await cubit.getProductsForCategory(null);
    final firstRequest = cubit.loadMoreProducts();
    await cubit.loadMoreProducts();
    expect(repository.requests, hasLength(2));

    repository.nextPageCompleter!.complete();
    await firstRequest;
    expect((cubit.state as ProductsSuccess).products, hasLength(21));

    await cubit.close();
  });

  test('refresh supersedes an in-flight next-page request', () async {
    final repository = _PaginatedHomeRepository()
      ..nextPageCompleter = Completer<void>();
    final cubit = HomeCubit(repository);

    await cubit.getProductsForCategory(null);
    final nextPageRequest = cubit.loadMoreProducts();
    await cubit.refreshProducts();
    expect((cubit.state as ProductsSuccess).isLoadingMore, isFalse);

    repository.nextPageCompleter!.complete();
    await nextPageRequest;
    expect((cubit.state as ProductsSuccess).products, hasLength(20));
    expect(repository.requests.map((request) => request.offset), [0, 20, 0]);

    await cubit.close();
  });

  test('refresh reloads page one and replaces the product list', () async {
    final repository = _PaginatedHomeRepository();
    final cubit = HomeCubit(repository);

    await cubit.getProductsForCategory(null);
    await cubit.loadMoreProducts();
    repository.changeProductsOnRefresh = true;

    await cubit.refreshProducts();

    final state = cubit.state as ProductsSuccess;
    expect(state.products, hasLength(20));
    expect(state.products.first.id, 101);
    expect(state.hasMore, isTrue);
    expect(repository.requests.last.offset, 0);

    await cubit.close();
  });

  test('failed refresh keeps products visible and can be retried', () async {
    final repository = _PaginatedHomeRepository();
    final cubit = HomeCubit(repository);

    await cubit.getProductsForCategory(null);
    repository.failNextFirstPage = true;
    await cubit.refreshProducts();

    var state = cubit.state as ProductsSuccess;
    expect(state.products, hasLength(20));
    expect(state.refreshErrorMessage, contains('Refresh failed.'));

    await cubit.loadMoreProducts();
    expect(repository.requests, hasLength(2));

    await cubit.refreshProducts();
    state = cubit.state as ProductsSuccess;
    expect(state.products, hasLength(20));
    expect(state.refreshErrorMessage, isNull);

    await cubit.close();
  });
}
