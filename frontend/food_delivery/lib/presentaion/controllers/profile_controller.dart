import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/user_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Text controllers for form fields
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  String? selectedGender; // Default value
  final List<String> genderOptions = ['Male', 'Female'];

  ProfileController() {
    // Initialize controllers with current user data
    nameController = TextEditingController(text: currentUser?.name ?? '');
    phoneController =
        TextEditingController(text: currentUser?.phoneNumber ?? '');
    emailController = TextEditingController(text: currentUser?.email ?? '');
    selectedGender = currentUser?.gender ?? 'Male';
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void updateGender(String newGender) {
    selectedGender = newGender;
    update(); // Notify GetBuilder
  }

  bool isUpdatingLoading = false;
  Future<void> updateProfile() async {
    if (currentUser == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    try {
      isUpdatingLoading = true;
      update();
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender,
      });

      // Update global currentUser (plain variable)
      currentUser = UserModel(
        uid: currentUser!.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        gender: selectedGender!,
        address: currentUser!.address, // Preserve location
      );

      Get.snackbar('Success', 'Profile updated successfully');
      update(); // Notify GetBuilder
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isUpdatingLoading = false;
      update();
    }
  }

  Future<void> updateUserAddress(String newAddress) async {
    if (currentUser == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    try {
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({
        'address': newAddress,
      });

      // Update global currentUser
      currentUser = UserModel(
        uid: currentUser!.uid,
        name: currentUser!.name,
        email: currentUser!.email,
        phoneNumber: currentUser!.phoneNumber,
        gender: currentUser!.gender,
        address: newAddress,
      );

      Get.snackbar('Success', 'Address updated successfully');
      update(); // Notify GetBuilder
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address: $e');
    }
  }

  bool isSavingChanges = false;
  // New function to change password
  Future<bool> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    if (currentUser == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar('Error', 'New password and confirmation do not match');
      return false;
    }

    if (newPassword.length < 6) {
      Get.snackbar('Error', 'New password must be at least 6 characters long');
      return false;
    }

    try {
      // Re-authenticate the user with their old password
      isSavingChanges = true;
      update();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      Get.snackbar('Success', 'Password updated successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password: ${e.toString()}');
      return false;
    } finally {
      isSavingChanges = false;
      update();
    }
  }

  bool isDeletingLoading = false;

  // New function to delete account
  Future<bool> deleteAccount() async {
    if (currentUser == null) {
      Get.snackbar('Error', 'User not logged in');
      return false;
    }

    try {
      isDeletingLoading = true;
      update();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      // Delete user data from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .delete();

      // Delete the user account from Firebase Authentication
      await user.delete();

      // Clear global currentUser
      currentUser = null;
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: ${e.toString()}');
      return false;
    } finally {
      isDeletingLoading = false;
      update();
    }
  }
}
