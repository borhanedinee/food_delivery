import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ProductModel> allProducts = <ProductModel>[]; // All fetched products
  List<ProductModel> filteredProducts = <ProductModel>[]; // Filtered products
  final TextEditingController searchController = TextEditingController();
  var isLoading = false;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch all products from Firestore once
  Future<void> fetchAllProducts() async {
    try {
      isLoading = true;
      update();
      final querySnapshot = await _firestore.collection('products').get();
      allProducts = querySnapshot.docs
          .map((doc) => ProductModel.fromJson({
                ...doc.data(),
                'id': doc.id, // Include document ID
              }))
          .toList();
      filteredProducts = allProducts; // Initially show all products
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  // Filter products locally by category
  List<ProductModel> filterProductsByCategory(String category) {
    if (category.toLowerCase() == 'juices') {
      category = 'jus';
    }
    if (category.isEmpty) {
      filteredProducts = allProducts; // Show all if no category
    } else {
      filteredProducts = allProducts
          .where((product) =>
              product.category.toLowerCase().contains(category.toLowerCase()))
          .toList();
    }
    return filteredProducts;
  }
}
