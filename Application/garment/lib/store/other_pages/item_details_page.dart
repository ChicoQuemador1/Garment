import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garment/store/models/product.dart';

class ItemDetailsPage extends StatefulWidget {
  final String itemId; // Changed from int to String to match Firestore IDs
  const ItemDetailsPage({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemDetailsPage> createState() => ItemDetailsPageState();
}

class ItemDetailsPageState extends State<ItemDetailsPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Product?> fetchProductById() async {
    try {
      var doc = await db.collection('products').doc(widget.itemId).get();
      if (doc.exists) {
        return Product.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print(
          e); // Consider handling error scenarios, possibly showing an error message to the user
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<Product?>(
        future: fetchProductById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading product details'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Product not found'));
          }
          Product product = snapshot.data!;
          return ListView(
            children: [
              Image.network(product.imageUrl, height: 250, fit: BoxFit.cover),
              ListTile(
                title: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Size: ${product.size}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Condition: ${product.condition}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Brand: ${product.brand}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text('Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(product.description),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () {}, // Placeholder for add to bag functionality
                      child: const Text('Add to Bag',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
