// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text("Name of Item $bagIndex")),
                              visualDensity: VisualDensity(vertical: 4),
                              leading: Image(
                                height: 100,
                                width: 60,
                                image: AssetImage("images/test_image0.png"),
                              ),
                              subtitle: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text("Cost • Size • Brand")),
                              trailing: GestureDetector(
                                onTap: () {
                                  debugPrint("Delete item $bagIndex");
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Text("Delete")),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, bagIndex) =>
                          Divider(),
                      itemCount: 10),
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
                              "Total: \$1,000.00",
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: GestureDetector(
                                onTap: () {
                                  debugPrint("Go to checkout");
                                },
                                child: Container(
                                  height: 50,
                                  width: size.width / 2.5,
                                  decoration: BoxDecoration(
                                      color: Colors.black87,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 4, 5, 1),
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
      ),
    );
  }
}
