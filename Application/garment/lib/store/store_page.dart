// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:garment/store/categories/menswear_page.dart';
import 'package:garment/store/categories/otherswear_page.dart';
import 'package:garment/store/categories/womenswear_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> storeTabs = <Tab>[
    Tab(
      text: "WOMENSWEAR",
    ),
    Tab(
      text: "MENSWEAR",
    ),
    Tab(
      text: "OTHER",
    ),
  ];

  // ignore: unused_field
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: storeTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: storeTabs.length,
      child: Builder(builder: (BuildContext context) {
        _tabController = DefaultTabController.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Image(image: AssetImage("images/logo.png"))),
            titleSpacing: 10,
            toolbarHeight: 95,
            bottom: TabBar(
              labelStyle: TextStyle(
                fontFamily: "Sniglet",
                fontSize: 14,
                color: Colors.black,
              ),
              indicatorColor: Colors.black,
              tabs: storeTabs,
            ),
          ),
          body: TabBarView(
            children: [
              WomenswearPage(),
              MenswearPage(),
              OtherswearPage(),
            ],
          ),
        );
      }),
    );
  }
}
