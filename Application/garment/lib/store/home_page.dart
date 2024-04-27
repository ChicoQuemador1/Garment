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
  final List<String> imageList = ["test_image0.png", "test_image1."];

  final List<int> popularListId = [];

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
  initState() {
    super.initState();
    buildPopularItems();
  }

  void buildPopularItems() {
    db
        .collection('items')
        .orderBy("popularity", descending: true)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        debugPrint("${doc["id"]}");
        popularListId.add(doc["id"]);
      }
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
              // Search Bar
              SizedBox(height: 20),
              /*
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SearchAnchor(builder:
                    (BuildContext context, SearchController controller) {
                  return SearchBar(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Colors.white;
                    }),
                    elevation: MaterialStateProperty.resolveWith((states) {
                      return 0;
                    }),
                    side: MaterialStateProperty.resolveWith((states) {
                      return BorderSide();
                    }),
                    hintText: "Find your new style easy.",
                    controller: controller,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                }, suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        });
                  });
                }),
              ),
              */
              // Popular Text and Arrow
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
                    itemBuilder: (BuildContext context, popIndex) => Container(
                      // Get rid of decoration later
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(24)),
                      height: 100,
                      width: 100,
                      child: GestureDetector(
                        onTap: () => goToItemPage(popIndex),
                        child: Image(
                          image: AssetImage("images/test_image1.png"),
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, popIndex) =>
                        VerticalDivider(color: Colors.white, width: 25),
                    itemCount: 10,
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
                    itemBuilder: (BuildContext context, popIndex) => Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(24)),
                      height: 100,
                      width: 100,
                    ),
                    separatorBuilder: (BuildContext context, popIndex) =>
                        VerticalDivider(color: Colors.white, width: 25),
                    itemCount: 10,
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
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(24),
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
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(24),
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
