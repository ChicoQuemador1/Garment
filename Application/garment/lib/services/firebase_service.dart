import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../store/models/product.dart';
import '../store/models/bag_product.dart'; // Ensure you have this import for bag product model

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
    var bagRef = _db
        .collection('bags')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: bagProduct.productId);
    var querySnapshot = await bagRef.get();

    if (querySnapshot.docs.isEmpty) {
      // Product is not in the bag, add it
      await _db.collection('bags').add(bagProduct.toMap());
      return true; // Successfully added
    } else {
      return false; // Product already in bag
    }
  }

  // Remove product from the bag
  Future<void> removeProductFromBag(String bagProductId) async {
    await _db.collection('bags').doc(bagProductId).delete();
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
        await _db.collection('bags').where('userId', isEqualTo: userId).get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
