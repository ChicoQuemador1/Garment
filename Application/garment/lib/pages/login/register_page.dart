// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      // Create User
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add User Details
      addUserDetails(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Passwords do not match."),
            );
          });
    }
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Logo
                SizedBox(height: 40),
                Image(image: AssetImage('images/logo.png')),
                // Add some sort of slogan
                Text(
                  "Register Below!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Sniglet',
                  ),
                ),

                // First Name Text Field
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name',
                          hintStyle: TextStyle(
                            fontFamily: 'Sniglet',
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Last Name Text Field
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last Name',
                          hintStyle: TextStyle(
                            fontFamily: 'Sniglet',
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Email Address Text Field
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontFamily: 'Sniglet',
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Password Text Field
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontFamily: 'Sniglet',
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Confirm Password Text Field
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            fontFamily: 'Sniglet',
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Sign In Button
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Sniglet',
                            ),
                          ),
                        )),
                  ),
                ),

                // I have an Account
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 70),
                    Text(
                      "I have an account",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        fontFamily: 'Sniglet',
                      ),
                    ),

                    // Register
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'Sniglet',
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
