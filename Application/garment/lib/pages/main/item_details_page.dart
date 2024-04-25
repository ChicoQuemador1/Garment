// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../components/product_item.dart';

class ItemDetailsPage extends StatefulWidget {
  final int itemId;
  const ItemDetailsPage({super.key, required this.itemId});

  @override
  State<ItemDetailsPage> createState() => ItemDetailsPageState();
}

class ItemDetailsPageState extends State<ItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // Product Image
          Center(
            child: Container(
              decoration: BoxDecoration(),
              child: Image(
                width: 250,
                image: AssetImage("images/test_image0.png"),
              ),
            ),
          ),

          // Information Tab
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  width: double.infinity,
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.itemId.toString()),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                      Text("HiHiHiHiHiHi"),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                  ),
                  width: double.infinity,
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ByeByeByeByeByeByeByeByeByeBye"),
                      Text("ByeByeByeByeByeByeByeByeByeBye"),
                      Text("ByeByeByeByeByeByeByeByeByeBye"),
                      Text("ByeByeByeByeByeByeByeByeByeBye"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
