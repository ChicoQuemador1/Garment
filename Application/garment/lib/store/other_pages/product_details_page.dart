// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garment/store/models/product.dart';
import 'package:garment/services/firebase_service.dart'; // Ensure FirebaseService is correctly imported

class ItemDetailsPage extends StatefulWidget {
  final String itemId; // This ID is passed when navigating to this page
  const ItemDetailsPage({super.key, required this.itemId});

  @override
  State<ItemDetailsPage> createState() => ItemDetailsPageState();
}

class ItemDetailsPageState extends State<ItemDetailsPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseService firebaseService =
      FirebaseService(); // Instance of FirebaseService

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

  late var userId;
  void getUserId() {
    db
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((value) {
      debugPrint(value.docs[0].id);
      userId = value.docs[0].id;
    });
  }

  // New method to handle adding to bag
  void addToBag(Product product) async {
    getUserId();

    var result = await firebaseService.addProductToBag(
        userId, product.id, product.toBagProduct());
    final snackBar = SnackBar(
      content: Text(
          result ? 'Added to bag successfully!' : 'Item already in your bag!'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
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
                height: size.height / 2,
                child: Image.network(product.imageUrl,
                    height: 250, fit: BoxFit.cover),
              ),
              Container(
                height: size.height / 2,
                width: size.width,
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.brand,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "Sniglet")),
                      Text("${product.name} (test length)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: "Sniglet")),
                      Text(product.description,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "Sniglet")),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Size: ${product.size}',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: "Sniglet")),
                                Text('Condition: ${product.condition}',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: "Sniglet")),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("\$$product.price"),
                              GestureDetector(
                                onTap: () => addToBag(product),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 75,
                                  width: size.width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black45,
                                  ),
                                  child: Text("Add to Bag",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Sniglet",
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
