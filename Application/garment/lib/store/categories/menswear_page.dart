// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garment/store/models/product.dart';
import 'package:garment/store/other_pages/product_details_page.dart';

class MenswearPage extends StatefulWidget {
  const MenswearPage({Key? key}) : super(key: key);

  @override
  State<MenswearPage> createState() => _MenswearPageState();
}

class _MenswearPageState extends State<MenswearPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    print('Fetching products for category: Menswear');
    return _db
        .collection('products')
        .where('category', isEqualTo: 'Menswear')
        .snapshots()
        .map((snapshot) {
      print('Fetched ${snapshot.docs.length} products');
      return snapshot.docs
          .map((doc) =>
              Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 1),
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
                  padding: const EdgeInsets.all(1.0),
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    ),
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
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
