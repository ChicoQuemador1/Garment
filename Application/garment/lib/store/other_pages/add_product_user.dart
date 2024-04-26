// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();
  final _conditionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _imageURLController = TextEditingController();

  @override
  dispose() {
    _brandController.dispose();
    _categoryController.dispose();
    _conditionController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo and Slogan setup
              const Image(image: AssetImage('images/logo.png')),
              const Text(
                "Add a Product to the Catalog!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Sniglet',
                ),
              ),
              const SizedBox(height: 20),

              // Input fields
              buildTextField(_nameController, 'Name of Product'),
              const SizedBox(height: 10),
              buildTextField(_descriptionController, 'Description'),
              const SizedBox(height: 10),
              buildTextField(_brandController, 'Brand Name'),
              const SizedBox(height: 10),
              DropdownMenu(
                controller: _categoryController,
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(value: "Womenswear", label: "Womenswear"),
                  DropdownMenuEntry(value: "Menswear", label: "Menswear"),
                  DropdownMenuEntry(value: "Other", label: "Other"),
                ],
                width: size.width - 50,
                enableFilter: true,
                label: Text("Category"),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    DropdownMenu(
                      controller: _sizeController,
                      dropdownMenuEntries: <DropdownMenuEntry>[
                        DropdownMenuEntry(value: "XS", label: "XS"),
                        DropdownMenuEntry(value: "S", label: "S"),
                        DropdownMenuEntry(value: "M", label: "M"),
                        DropdownMenuEntry(value: "L", label: "L"),
                        DropdownMenuEntry(value: "XL", label: "XL"),
                      ],
                      width: size.width / 3,
                      label: Text("Size"),
                    ),
                    SizedBox(width: 20),
                    DropdownMenu(
                      controller: _conditionController,
                      dropdownMenuEntries: <DropdownMenuEntry>[
                        DropdownMenuEntry(value: "New", label: "New"),
                        DropdownMenuEntry(
                            value: "Barely Used", label: "Barely Used"),
                        DropdownMenuEntry(value: "Used", label: "Used"),
                      ],
                      width: size.width / 2.1,
                      label: Text("Condition"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              buildTextField(_priceController, 'Price'),
              const SizedBox(height: 10),
              buildTextField(_imageURLController, 'Image URL'),

              // Add Product Button
              const SizedBox(height: 20),
              buildAddProductButton(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(TextEditingController controller, String hintText,
    {bool isObscure = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Container(
      height: 45,
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
    ),
  );
}

Widget buildAddProductButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Add Product",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Sniglet',
            ),
          ),
        ),
      ),
    ),
  );
}

/*
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/product.dart';
import '../services/firebase_service.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> addProduct() async {
    if (_image != null) {
      FirebaseService firebaseService = FirebaseService();
      Product product = Product(
        id: '', // ID will be generated by Firestore
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageUrl: '', // Will be set after image upload
      );
      await firebaseService.addProduct(product, _image!);
      Navigator.pop(context); // Optionally pop back on success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
            _image != null ? Image.file(_image!) : Container(),
            ElevatedButton(
              onPressed: addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
