import 'package:museo_admin_application/models/store/product_category.dart';

class Product {
  String id, name, description, image, size, color;
  ProductCategory category;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.size,
    required this.price,
    required this.color,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final category = ProductCategory.fromJson(json['category']);

    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      size: json['size'],
      color: json['color'],
      category: category,
    );
  }
}
