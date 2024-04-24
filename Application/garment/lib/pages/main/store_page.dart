// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:garment/pages/main/categories/menswear_page.dart';
import 'package:garment/pages/main/categories/otherswear_page.dart';
import 'package:garment/pages/main/categories/womenswear_page.dart';

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
        _tabController?.addListener(() {
          if (_tabController!.indexIsChanging) {
            // Add a way to implement the change between contents here
          }
        });
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
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
