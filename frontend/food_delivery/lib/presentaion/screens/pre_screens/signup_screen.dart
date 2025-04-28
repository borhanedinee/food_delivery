import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/auth_controller.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_root.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  String selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  bool isPasswordHidden = true;

  Future<void> showLocationSearchDialog(
      BuildContext context, Function(String) onLocationSelected) async {
    final TextEditingController searchController = TextEditingController();
    List<dynamic> searchResults = [];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Search Location'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search location (e.g., Oran, Algeria)...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                    ),
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        setState(() {
                          searchResults = [];
                        });
                        return;
                      }

                      try {
                        final response = await http.get(
                          Uri.parse(
                            'https://nominatim.openstreetmap.org/search?q=$value&format=json&addressdetails=1&limit=5',
                          ),
                          headers: {
                            'User-Agent':
                                'FoodDeliveryApp (contact@example.com)',
                          },
                        );

                        if (response.statusCode == 200) {
                          setState(() {
                            searchResults = jsonDecode(response.body);
                          });
                        } else {
                          Get.snackbar('Error', 'Failed to fetch locations');
                        }
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to fetch locations: $e');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: searchResults.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final result = searchResults[index];
                              final displayName =
                                  result['display_name'] ?? 'Unknown Location';
                              return ListTile(
                                title: Text(displayName),
                                onTap: () {
                                  onLocationSelected(displayName);
                                  Get.back();
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.darkerPrimaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/app_logo.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 32),
                  MyTextField(
                    keyboardType: TextInputType.name,
                    controller: fullNameController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Full name',
                    prefixIcon: Icon(Icons.person_2_rounded,
                        color: AppColors.blackColor),
                  ),
                  SizedBox(height: 16),
                  MyTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: AppColors.blackColor),
                  ),
                  SizedBox(height: 16),
                  MyTextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: AppColors.blackColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        isPasswordHidden
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.blackColor,
                      ),
                    ),
                    obscureText: isPasswordHidden,
                  ),
                  SizedBox(height: 16),
                  MyTextField(
                    controller: phoneNumberController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: AppColors.blackColor),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                    items: genderOptions.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      hintText: 'Select Gender',
                      filled: true,
                      fillColor: AppColors.whiteColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showLocationSearchDialog(context, (selectedLocation) {
                        setState(() {
                          addressController.text = selectedLocation;
                        });
                      });
                    },
                    child: MyTextField(
                      controller: addressController,
                      fillColor: AppColors.whiteColor,
                      hintText: 'Select Address',
                      prefixIcon:
                          Icon(Icons.location_on, color: AppColors.blackColor),
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: 32),
                  GetBuilder<AuthController>(
                    builder: (controller) => controller.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (fullNameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  phoneNumberController.text.isEmpty ||
                                  addressController.text.isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'Please fill all fields',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                bool status = await controller.signUp(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  fullNameController.text.trim(),
                                  phoneNumberController.text.trim(),
                                  addressController.text.trim(),
                                  selectedGender,
                                );
                                if (status) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => NavBarScreen(),
                                    ),
                                    (Route<dynamic> route) =>
                                        false, // Remove all previous routes
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 16),
                              elevation: 2,
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            child: Text(
                              'Create Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Have an account? Log in',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
