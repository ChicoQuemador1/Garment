// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WomenswearPage extends StatefulWidget {
  const WomenswearPage({super.key});

  @override
  State<WomenswearPage> createState() => WomenswearPageState();
}

class WomenswearPageState extends State<WomenswearPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 575,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GridTile(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text("item $index"),
                      ),
                    ),
                  );
                },
                itemCount: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
