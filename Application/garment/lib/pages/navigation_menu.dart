// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Paths to other pages
import 'main/home_page.dart';
import 'main/store_page.dart';
import 'main/profile_page.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final user = FirebaseAuth.instance.currentUser!;
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.selected)
                    ? TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sniglet',
                      )
                    : TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sniglet',
                      ),
          ),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.selected)
                    ? IconThemeData(color: Colors.black87)
                    : IconThemeData(color: Colors.white),
          ),
          indicatorColor: Colors.grey[300],
        ),
        child: NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: Colors.black87,
          selectedIndex: currentPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_rounded),
              label: "Store",
            ),
            NavigationDestination(
              icon: Icon(Icons.local_mall),
              label: "Bag",
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: Center(
        child: <Widget>[
          HomePage(),
          StorePage(),
          HomePage(),
          ProfilePage(),
        ][currentPageIndex],
      ),
    );
  }
}
