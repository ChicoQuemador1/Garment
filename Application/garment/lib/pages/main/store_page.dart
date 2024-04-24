// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: [
              Tab(
                child: GestureDetector(
                  child: Text(
                    "WOMENSWEAR",
                    style: TextStyle(
                      fontFamily: "Sniglet",
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Tab(
                child: GestureDetector(
                  child: Text(
                    "MENSWEAR",
                    style: TextStyle(
                      fontFamily: "Sniglet",
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Tab(
                child: GestureDetector(
                  child: Text(
                    "OTHER",
                    style: TextStyle(
                      fontFamily: "Sniglet",
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SafeArea(
            child: Center(
                /*
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
              ),*/
                ),
          ),
        ),
      ),
    );
  }
}
