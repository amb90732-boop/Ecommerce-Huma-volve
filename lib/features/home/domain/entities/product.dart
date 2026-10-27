import 'category.dart';

class Product {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required List<String> images,
  }) : images = List.unmodifiable(images);

  final int id;
  final String title;
  final int price;
  final String description;
  final Category? category;
  final List<String> images;
}
