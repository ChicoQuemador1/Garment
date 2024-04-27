// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garment/store/models/bag_product.dart';

import '../services/firebase_service.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseService firebaseService = FirebaseService();
  var userId;

  Stream<List<BagProduct>> getBagProducts() {
    getUserId();
    return _db
        .collection('users')
        .doc(userId)
        .collection('bag')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BagProduct.fromMap(doc.data(), doc.id))
            .toList());
  }

  void getUserId() async {
    _db
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((value) {
      userId = value.docs[0].id;
    });
  }

  removeProductFromBag(BagProduct bagProduct) async {
    getUserId();
    await firebaseService.removeProductFromBag(userId, bagProduct);
  }

  @override
  initState() {
    super.initState();
    getUserId();
    getBagProducts();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) => StreamBuilder<List<BagProduct>>(
          stream: getBagProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                    textAlign: TextAlign.center,
                    "There is nothing in your bag.\n Go to Home or Store to find your new style easy.",
                    style: TextStyle(
                      fontFamily: "Sniglet",
                      fontSize: 16,
                    )),
              );
            }
            double total = 0;
            for (var i = 0; i < snapshot.data!.length; i++) {
              total += snapshot.data![i].price;
            }
            return SafeArea(
              child: Center(
                child: ListView(
                  children: [
                    // List of Items in Cart
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: SizedBox(
                        height: 600,
                        child: ListView.separated(
                            itemBuilder: (BuildContext context, bagIndex) {
                              BagProduct bagProduct = snapshot.data![bagIndex];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(bagProduct.name,
                                        style: TextStyle(fontSize: 18)),
                                    visualDensity: VisualDensity(vertical: 4),
                                    leading: Image.network(bagProduct.imageUrl,
                                        fit: BoxFit.cover),
                                    subtitle: Text(
                                        '\$${bagProduct.price}' " • " +
                                            bagProduct.size +
                                            " • " +
                                            bagProduct.brand,
                                        style: TextStyle(fontSize: 14)),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        removeProductFromBag(bagProduct);
                                        debugPrint("Delete item $bagIndex");
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, bagIndex) => Divider(),
                            itemCount: snapshot.data!.length),
                      ),
                    ),

                    // Row that holds cost and checkout button
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Total cost of all items
                          SizedBox(
                            height: 70,
                            width: (size.width / 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    "Total: \$$total",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontFamily: "Sniglet",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Checkout Button
                          SizedBox(
                            height: 70,
                            width: size.width / 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        debugPrint("Go to checkout");
                                      },
                                      child: Container(
                                        height: 50,
                                        width: size.width / 2.5,
                                        decoration: BoxDecoration(
                                            color: Colors.black87,
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 4, 5, 1),
                                          child: Text(
                                            "Checkout",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: "Sniglet",
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        future: Future.delayed(Duration(seconds: 1)),
      ),
    );
  }
}
