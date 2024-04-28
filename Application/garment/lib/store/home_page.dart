// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garment/store/other_pages/product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final List<String> popularListId = [];
  final List<String> newListId = [];

  void goToItemPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(
          itemId: popularListId[index].toString(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  void fetchItems() async {
    await buildPopularItems();
    await buildNewItems();
  }

  Future<void> buildPopularItems() async {
    var querySnapshot = await db
        .collection('products')
        .orderBy("clickCount", descending: true)
        .limit(10)
        .get();

    setState(() {
      popularListId.clear();
      popularListId.addAll(querySnapshot.docs.map((doc) => doc.id).toList());
    });
  }

  Future<void> buildNewItems() async {
    var querySnapshot = await db
        .collection('products')
        .orderBy("createdAt", descending: true)
        .limit(10)
        .get();

    setState(() {
      newListId.clear();
      newListId.addAll(querySnapshot.docs.map((doc) => doc.id).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Image(image: AssetImage("images/logo.png"))),
        titleSpacing: 10,
        toolbarHeight: 95,
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              SizedBox(height: 20),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 5),
                    child: Text(
                      "Popular",
                      style: TextStyle(
                        fontFamily: "Sniglet",
                        fontSize: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 190),
                  Text(
                    "slide",
                    style: TextStyle(
                      fontFamily: "Sniglet",
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.black, size: 40),
                ],
              ),

              // Popular Items
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: db
                            .collection('products')
                            .doc(popularListId[index] as String?)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!.data() == null) {
                            return Container(); // Or some placeholder widget
                          }
                          var productData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () => goToItemPage(
                                index), // Adjusted for both lists if needed
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 100,
                              width: 100,
                              child: Image.network(productData['imageUrl'],
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        VerticalDivider(color: Colors.white, width: 25),
                    itemCount: popularListId.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),

              // New Text and Arrow
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 5),
                    child: Text(
                      "New",
                      style: TextStyle(
                        fontFamily: "Sniglet",
                        fontSize: 28,
                      ),
                    ),
                  ),
                  SizedBox(width: 235),
                  Text(
                    "slide",
                    style: TextStyle(
                      fontFamily: "Sniglet",
                      fontSize: 14,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.black, size: 40),
                ],
              ),

              // New Items
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SizedBox(
                  height: 100,
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: db
                            .collection('products')
                            .doc(newListId[index])
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!.data() == null) {
                            return Container(); // Or some placeholder widget
                          }
                          var productData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () => goToItemPage(
                                index), // Assuming newListId handling
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 100,
                              width: 100,
                              child: Image.network(productData['imageUrl'],
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        VerticalDivider(color: Colors.white, width: 25),
                    itemCount: newListId.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              // Advertisement for sale or something???
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 150,
                ),
              ),

              // Almost Out ???
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 150,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
