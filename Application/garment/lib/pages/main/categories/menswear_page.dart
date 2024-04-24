// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MenswearPage extends StatefulWidget {
  const MenswearPage({super.key});

  @override
  State<MenswearPage> createState() => _MenswearPageState();
}

class _MenswearPageState extends State<MenswearPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 530,
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
                itemCount: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
