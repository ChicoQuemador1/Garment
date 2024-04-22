import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // TEMPORARY Sign out
              SizedBox(height: 50),
              Text(
                "signed in as: ${user.email!}",
                style: TextStyle(
                  fontFamily: 'Sniglet',
                ),
              ),
              // Sign Out Button
              MaterialButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                color: Colors.black54,
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
