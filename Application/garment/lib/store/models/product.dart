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
      name: data['name'] ?? 'Unknown',
      price: _ensureDouble(data['price']),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? 'default_image.png',
      size: data['size'] ?? 'N/A',
      condition: data['condition'] ?? 'N/A',
      brand: data['brand'] ?? 'No Brand',
    );
  }

// Helper function to convert any input to a double
  static double _ensureDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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
      id: '',
      productId: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      size: size,
      brand: brand,
    );
  }
}
