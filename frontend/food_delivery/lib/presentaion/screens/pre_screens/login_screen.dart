import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/auth_controller.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_root.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/signup_screen.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                    obscureText: isPasswordHidden,
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
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
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
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                Get.snackbar(
                                    'Error', 'Please fill in all fields',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              } else {
                                bool status = await controller.login(
                                    emailController.text,
                                    passwordController.text);

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
                              'Login',
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
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.whiteColor,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Or Login with',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Divider(
                          color: AppColors.whiteColor,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/apple.png',
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        'assets/icons/google.png',
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Image.asset(
                        'assets/icons/facebook.png',
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Navigate to the signup screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign up',
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
