// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garment/store/models/product.dart';

class ItemDetailsPage extends StatefulWidget {
  final String itemId; // Changed from int to String to match Firestore IDs
  const ItemDetailsPage({super.key, required this.itemId});

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
                      height: 250, fit: BoxFit.cover)),
              Container(
                height: size.height / 2,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: SizedBox(
                  width: size.width / 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.brand,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "Sniglet",
                            )),
                        Text("${product.name} (test length)",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontFamily: "Sniglet",
                            )),
                        Text(product.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "Sniglet",
                            )),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width / 2 - 30,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Size: ${product.size}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Sniglet",
                                        )),
                                    Text('Condition: ${product.condition}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Sniglet",
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: size.width / 2,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 20, 30, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: 50),
                                          Text(
                                              '\$${product.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: "Sniglet",
                                                fontWeight: FontWeight.bold,
                                              )),
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint("Add to Cart works");
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 75,
                                              width: size.width / 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.black45,
                                              ),
                                              child: Text("Add to Bag",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Sniglet",
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
