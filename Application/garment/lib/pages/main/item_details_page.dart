// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({super.key});

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
                image: AssetImage("images/test_image.png"),
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
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                  ),
                  width: double.infinity,
                  height: 400,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
