import '../../domain/entities/product.dart';
import 'category_model.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    this.category,
    this.slug,
    this.creationAt,
    this.updatedAt,
  });

  final int id;
  final String title;
  final int price;
  final String description;
  final List<String> images;
  final CategoryModel? category;
  final String? slug;
  final String? creationAt;
  final String? updatedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final price = json['price'];
    final description = json['description'];
    final rawImages = json['images'];
    if (id is! int ||
        title is! String ||
        price is! num ||
        description is! String ||
        rawImages is! List) {
      throw const FormatException('Invalid product response.');
    }

    final rawCategory = json['category'];
    return ProductModel(
      id: id,
      title: title,
      price: price.toInt(),
      description: description,
      images: List.unmodifiable(rawImages.whereType<String>()),
      category: rawCategory is Map<String, dynamic>
          ? CategoryModel.fromJson(rawCategory)
          : null,
      slug: json['slug'] as String?,
      creationAt: json['creationAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Product toEntity() => Product(
    id: id,
    title: title,
    price: price,
    description: description,
    category: category?.toEntity(),
    images: List.unmodifiable(images),
  );
}
