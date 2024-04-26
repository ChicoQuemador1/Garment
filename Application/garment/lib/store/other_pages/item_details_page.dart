// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

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
    Size size = MediaQuery.of(context).size;
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
              // Product Image
              SizedBox(
                  height: size.height / 2.5,
                  child: Image.network(product.imageUrl,
                      height: 250, fit: BoxFit.cover)),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 500,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.brand,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "Sniglet",
                              )),
                          Text(product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontFamily: "Sniglet",
                              )),
                          Text(product.brand,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: "Sniglet",
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 400,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              // Product Name
              ListTile(
                title: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                // Product Price
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              ),
              // Product Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Size
                    Text('Size: ${product.size}',
                        style: const TextStyle(fontSize: 16)),
                    // Condition
                    Text('Condition: ${product.condition}',
                        style: const TextStyle(fontSize: 16)),
                    // Brand
                    Text('Brand: ${product.brand}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    // Description
                    const Text('Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(product.description),
                    const SizedBox(height: 20),
                    // Add to Bag Button
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
