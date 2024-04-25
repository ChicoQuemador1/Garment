// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garment/models/product.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Womenswear"),
            Tab(text: "Menswear"),
            Tab(text: "Other"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CategoryProductsPage(category: "WOMENSWEAR"),
          CategoryProductsPage(category: "MENSWEAR"),
          CategoryProductsPage(category: "OTHER"),
        ],
      ),
    );
  }
}

class CategoryProductsPage extends StatelessWidget {
  final String category;
  const CategoryProductsPage({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<Product> products = snapshot.data!.docs
            .map((doc) =>
                Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(products[index].imageUrl),
              title: Text(products[index].name),
              subtitle: Text("\$${products[index].price.toString()}"),
            );
          },
        );
      },
    );
  }
}
