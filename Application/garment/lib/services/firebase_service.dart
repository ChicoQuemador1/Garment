import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload product image and data
  Future<void> addProduct(Product product, File imageFile) async {
    String filePath = 'products/${DateTime.now()}.png';
    Reference storageReference = FirebaseStorage.instance.ref().child(filePath);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    String imageUrl = await storageReference.getDownloadURL();

    await _db.collection('products').add({
      ...product.toMap(),
      'imageUrl': imageUrl,
    });
  }

  // Fetch products
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList());
  }
}
