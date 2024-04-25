class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.imageUrl});

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      price: data['price'],
      description: data['description'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
