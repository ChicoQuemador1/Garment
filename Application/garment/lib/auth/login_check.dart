// ignore_for_file: prefer_const_constructors

/*
  Checks if user is authorized to login
  If so then goes to navigation bar, else return back to login page
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/navigation_menu.dart';
import 'auth_page.dart';

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NavigationMenu();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
