// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../store/models/product.dart';
import '../store/models/bag_product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  void getUserId() {
    _db
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((value) {
      return value.docs[0].id;
    });
  }

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

  // Fetch all products
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) =>
            Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  // Fetch products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _db
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Add product to the bag if it's not already there
  Future<bool> addProductToBag(String userId, BagProduct bagProduct) async {
    var querySnapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('bag')
        .where('productId', isEqualTo: bagProduct.productId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Product is not in the bag, add it
      await _db.collection('users').get().then((value) {
        _db
            .collection('users')
            .doc(userId)
            .collection('bag')
            .add(bagProduct.toMap());
      });
      return true; // Successfully added
    } else {
      return false; // Product already in bag
    }
  }

  // Increment product click count
  Future<void> incrementProductClick(String productId) async {
    var productRef = _db.collection('products').doc(productId);
    return _db.runTransaction((transaction) async {
      var productSnapshot = await transaction.get(productRef);
      int currentCount = productSnapshot.data()?['clickCount'] ?? 0;
      transaction.update(productRef, {'clickCount': currentCount + 1});
    });
  }

  // Remove product from the bag
  Future<void> removeProductFromBag(
      String userId, BagProduct bagProduct) async {
    var item = await _db
        .collection('users')
        .doc(userId)
        .collection('bag')
        .where('productId', isEqualTo: bagProduct.productId)
        .get();
    if (item.docs.isEmpty) {
    } else {
      await _db
          .collection('users')
          .doc(userId)
          .collection('bag')
          .doc(item.docs[0].id)
          .delete();
    }
  }

  // Update product in the bag
  Future<void> updateProductInBag(
      String bagProductId, Map<String, dynamic> updatedData) async {
    await _db.collection('bags').doc(bagProductId).update(updatedData);
  }

  // Clear the bag
  Future<void> clearBag(String userId) async {
    // Fetch all bag items for the user and delete each
    var snapshot =
        await _db.collection('users').doc(userId).collection('bag').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
