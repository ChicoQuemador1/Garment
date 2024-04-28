// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garment/store/models/product.dart';
import 'package:garment/store/other_pages/product_details_page.dart';

class WomenswearPage extends StatefulWidget {
  const WomenswearPage({Key? key}) : super(key: key);

  @override
  State<WomenswearPage> createState() => _WomenswearPageState();
}

class _WomenswearPageState extends State<WomenswearPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _db
        .collection('products')
        .where('category',
            isEqualTo:
                'Womenswear') // Assuming there's a 'category' field in your Firestore documents
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10 // Space between rows
                ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsPage(itemId: product.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black, width: 2), // Thicker border
                      borderRadius:
                          BorderRadius.circular(10), // Optional rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          5.0), // Padding between image and border
                      child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black54,
                          title: Text(product.name),
                          subtitle:
                              Text('\$${product.price.toStringAsFixed(2)}'),
                        ),
                        child:
                            Image.network(product.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
