import '../../domain/entities/category.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.image,
    this.creationAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? slug;
  final String? image;
  final String? creationAt;
  final String? updatedAt;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! int || name is! String) {
      throw const FormatException('Invalid category response.');
    }

    return CategoryModel(
      id: id,
      name: name,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      creationAt: json['creationAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Category toEntity() => Category(id: id, name: name);
}
