import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Sign In Function
  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Logo
              SizedBox(height: 100),
              Image(image: AssetImage('images/logo.png')),
              // Add some sort of slogan
              Text(
                "Find your new style easy.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Sniglet',
                ),
              ),
              SizedBox(height: 20),

              // Email Address Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: buildTextField(_emailController, 'Email'),
              ),

              SizedBox(height: 10),

              // Password Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: buildTextField(_passwordController, 'Password',
                    isObscure: true),
              ),

              // Sign In Button
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: buildButton("Sign in", signIn, primary: true),
              ),

              // Reset Password and Register Now
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Forgot Password
                  buildButton("Forgot Password?", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage()));
                  }),
                  SizedBox(width: 20),
                  // Register
                  buildButton("Register Account", widget.showRegisterPage),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText,
      {bool isObscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Sniglet',
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed,
      {bool primary = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(
              20), // Same padding as the "Sign in" button to match height
          decoration: BoxDecoration(
            color: primary ? Colors.black87 : Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: primary
                    ? 18
                    : 12, // Differentiate text size for primary button
                fontFamily: 'Sniglet',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
