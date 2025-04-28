import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/data/models/user_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false;

  // Sign Up
  Future<bool> signUp(
    String email,
    String password,
    String name,
    String phone,
    String address,
    String gender,
  ) async {
    if (!_isValidEmail(email)) {
      Get.snackbar('Error', 'Invalid email format');
      return false;
    }
    try {
      isLoading = true;
      update();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phone,
        'address': address,
        'gender': gender,
        'createdAt': Timestamp.now(),
      });
      final data = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (data.exists) {
        UserModel user = UserModel.fromFirestore(data.data()!, data.id);
        currentUser = user;
        Get.snackbar('Success', 'Logged in successfully');
        return true;
      } else {
        Get.snackbar('Error', 'Something went wrong please try again');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    if (!_isValidEmail(email)) {
      Get.snackbar('Error', 'Invalid email format');
      return false;
    }
    try {
      isLoading = true;
      update();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final data = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (data.exists) {
        UserModel user = UserModel.fromFirestore(data.data()!, data.id);
        currentUser = user;
        Get.snackbar('Success', 'Logged in successfully');
      } else {
        Get.snackbar('Error', 'Something went wrong please try again');
        return false;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(LoginScreen());
    currentUser = null;
    Get.snackbar('Success', 'Logged out');
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
