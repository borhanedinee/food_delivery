import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/data/models/cart_item.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isAddingToCardLoading = false;
  // Add product to cart
  Future<void> addToCart(
    String userId,
    ProductModel product,
    int quantity,
    List<Topping> selectedToppings,
  ) async {
    try {
      isAddingToCardLoading = true;
      update();

      final cartItemRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(product.id);

      // Check if item already exists
      final doc = await cartItemRef.get();
      if (doc.exists) {
        // Update quantity
        await cartItemRef.update({
          'quantity': FieldValue.increment(quantity),
          'toppings': selectedToppings.map((t) => t.toJson()).toList(),
        });
      } else {
        // Add new item
        await cartItemRef.set({
          'productId': product.id,
          'quantity': quantity,
          'toppings': selectedToppings.map((t) => t.toJson()).toList(),
          'name': product.name,
          'price': product.price,
          'avatar': product.avatar,
        });
      }
      await fetchCart(userId); // Refresh cart
      Get.snackbar('Success', '${product.name} added to cart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to cart: $e');
    } finally {
      isAddingToCardLoading = false;
      update();
    }
  }

  // Fetch cart items
  Future<void> fetchCart(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();
      cartItems = querySnapshot.docs
          .map((doc) => CartItem.fromJson(doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cart: $e');
    }
  }

  Future<void> updateQuantity(
      String userId, String productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeItem(userId, productId);
      } else {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(productId)
            .update({'quantity': newQuantity});
        await fetchCart(userId);
      }
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity: $e');
    }
  }

  Future<void> removeItem(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(productId)
          .delete();
      await fetchCart(userId);
      Get.snackbar('Success', 'Item removed from cart');
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item: $e');
    }
  }

  Future<void> placeOrder(String userId) async {
    try {
      if (cartItems.isEmpty) {
        Get.snackbar('Error', 'Cart is empty');
        return;
      }
      final orderId = _firestore.collection('orders').doc().id;
      final total =
          cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);
      await _firestore.collection('orders').doc(orderId).set({
        'userId': userId,
        'items': cartItems.map((item) => item.toJson()).toList(),
        'total': total,
        'createdAt': Timestamp.now(),
        'status': 'Pending',
      });

      // Clear cart
      final batch = _firestore.batch();
      final cartRef =
          _firestore.collection('users').doc(userId).collection('cart');
      final snapshot = await cartRef.get();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await fetchCart(userId);
      Get.snackbar('Success', 'Order placed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    }
  }
}
