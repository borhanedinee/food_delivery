import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/auth_controller.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_root.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // controllers
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;

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
                    controller: fullNameController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Full name',
                    prefixIcon: Icon(Icons.person_2_rounded,
                        color: AppColors.blackColor),
                  ),
                  SizedBox(height: 16),
                  MyTextField(
                    controller: emailController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: AppColors.blackColor),
                  ),
                  SizedBox(height: 16),
                  MyTextField(
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
                          color: AppColors.blackColor),
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
                  MyTextField(
                    controller: addressController,
                    fillColor: AppColors.whiteColor,
                    hintText: 'Address',
                    prefixIcon:
                        Icon(Icons.location_on, color: AppColors.blackColor),
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
                                );
                                if (status) {
                                  // Navigate to the home screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NavBarScreen(),
                                    ),
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
