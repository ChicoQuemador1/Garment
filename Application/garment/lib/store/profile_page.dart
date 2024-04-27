// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:garment/store/other_pages/add_product_user.dart';

import 'models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore db = FirebaseFirestore.instance;

  late final _firstNameController = TextEditingController();
  late final _lastNameController = TextEditingController();
  late final _phoneNumberController = TextEditingController();
  late final _addressController = TextEditingController();
  late final _cityController = TextEditingController();
  late final _stateController = TextEditingController();
  late final _zipController = TextEditingController();
  late final _paymentController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  late var userId;
  void getUserId() {
    db
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((value) {
      debugPrint(value.docs[0].id);
      userId = value.docs[0].id;
    });
  }

  Future<UserProfile?> fetchUserProfileById() async {
    getUserId();
    try {
      var doc = await db.collection('users').doc(userId as String).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print(
          e); // Consider handling error scenarios, possibly showing an error message to the user
    }
    return null;
  }

  void updateUserProfile(String field, String newValue) {
    getUserId();
    db.collection('users').doc(userId as String).update({field: newValue});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<UserProfile?>(
          future: fetchUserProfileById(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error User Profile'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('User not found'));
            }
            UserProfile profile = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: ListView(
                  children: [
                    // Welcome
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: Text(
                        "Hello ${profile.firstName}!",
                        style: TextStyle(
                          fontFamily: "Sniglet",
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Divider(
                      height: 4,
                    ),
                    Text(
                      "Profile Information",
                      style: const TextStyle(
                        fontFamily: 'Sniglet',
                        fontSize: 25,
                      ),
                    ),
                    // First Name
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text("First Name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 1.95,
                            child: Text(
                              profile.firstName,
                              style: TextStyle(
                                fontFamily: "Sniglet",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Edits First Name
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Change First Name"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          hintText: "First Name",
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          // Assign controller to update user field in database
                                          setState(() => updateUserProfile(
                                              'first name',
                                              _firstNameController.text
                                                  .trim()));
                                          _firstNameController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black87,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: "Sniglet",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 30,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Last Name
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text("Last Name"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 1.95,
                            child: Text(
                              profile.lastName,
                              style: TextStyle(
                                fontFamily: "Sniglet",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Edits Last Name
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Change Last Name"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _lastNameController,
                                        decoration: InputDecoration(
                                          hintText: "Last Name",
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          // Assign controller to update user field in database
                                          setState(() => updateUserProfile(
                                              'last name',
                                              _lastNameController.text.trim()));
                                          _lastNameController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black87,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: "Sniglet",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 30,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 4,
                    ),
                    Text(
                      "Personal Information",
                      style: const TextStyle(
                        fontFamily: 'Sniglet',
                        fontSize: 25,
                      ),
                    ),
                    // Email
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text("E-mail"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 1.95,
                            child: Text(
                              profile.email,
                              style: TextStyle(
                                fontFamily: "Sniglet",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Phone Number
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text("Phone Number"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 1.95,
                            child: Text(
                              "${profile.phone.substring(0, 3)}-${profile.phone.substring(3, 6)}-${profile.phone.substring(6)}",
                              style: TextStyle(
                                fontFamily: "Sniglet",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Edits Phone Number
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Change Phone Number"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                        ],
                                        controller: _phoneNumberController,
                                        decoration: InputDecoration(
                                          hintText: "Phone Number",
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          // Assign controller to update user field in database

                                          setState(() => updateUserProfile(
                                              'phone',
                                              _phoneNumberController.text
                                                  .trim()));
                                          _phoneNumberController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black87,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: "Sniglet",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 30,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Address
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text("Address"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: size.width / 1.95,
                                child: Text(
                                  profile.address,
                                  style: TextStyle(
                                    fontFamily: "Sniglet",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Edits First Name
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Change Address"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _addressController,
                                        decoration: InputDecoration(
                                          hintText: "Street Address",
                                        ),
                                      ),
                                      TextField(
                                        controller: _cityController,
                                        decoration: InputDecoration(
                                          hintText: "City",
                                        ),
                                      ),
                                      TextField(
                                        controller: _stateController,
                                        decoration: InputDecoration(
                                          hintText: "State",
                                        ),
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(5,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement
                                                      .enforced),
                                        ],
                                        controller: _zipController,
                                        decoration: InputDecoration(
                                          hintText: "ZIP Code",
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          // Assign controller to update user field in database
                                          String address =
                                              "${_addressController.text.trim()}\n${_cityController.text.trim()}, ${_stateController.text.trim()} ${_zipController.text.trim()}";
                                          setState(() => updateUserProfile(
                                              'address', address));
                                          _addressController.clear();
                                          _cityController.clear();
                                          _stateController.clear();
                                          _zipController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black87,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: "Sniglet",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 30,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Payment
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 4,
                            child: Text("Payment"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: size.width / 1.95,
                            child: Text(
                              "VISA: **** 1234",
                              style: TextStyle(
                                fontFamily: "Sniglet",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Edits First Name
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text("Change First Name"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          hintText: "First Name",
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                        onTap: () {
                                          // Assign controller to update user field in database
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.black87,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: "Sniglet",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 30,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 4,
                    ),
                    SizedBox(height: 20),
                    // Add Item
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductPage()));
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black87,
                        ),
                        child: Center(
                          child: Text(
                            "Add Item",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sniglet',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Call the sign out button method here
                    buildSignOutButton(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  // Define the button outside the build method
  Widget buildSignOutButton() {
    return GestureDetector(
      onTap: () {
        FirebaseAuth.instance.signOut();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87, // Match the color used in ForgotPasswordPage
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Sign Out',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Sniglet',
            ),
          ),
        ),
      ),
    );
  }
}
