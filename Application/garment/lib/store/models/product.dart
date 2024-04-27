import 'package:garment/store/models/bag_product.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String size;
  final String condition;
  final String brand;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.size,
    required this.condition,
    required this.brand,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      price: data['price'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      size: data['size'],
      condition: data['condition'],
      brand: data['brand'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'size': size,
      'condition': condition,
      'brand': brand,
    };
  }

  // Convert Product to BagProduct
  BagProduct toBagProduct() {
    return BagProduct(
      id: '', // ID will be empty or set by Firebase when adding to the collection
      productId: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      size: size,
      brand: brand,
    );
  }
}
