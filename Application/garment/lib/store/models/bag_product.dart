class BagProduct {
  final String id;
  final String productId; // Reference to the product ID
  final String name;
  final String imageUrl;
  final double price;
  final String size;
  final String brand;

  BagProduct({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.brand,
  });

  factory BagProduct.fromMap(Map<String, dynamic> data, String id) {
    return BagProduct(
      id: id,
      productId: data['productId'],
      name: data['name'],
      imageUrl: data['imageUrl'],
      price: data['price'],
      size: data['size'],
      brand: data['brand'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'size': size,
      'brand': brand,
    };
  }
}
