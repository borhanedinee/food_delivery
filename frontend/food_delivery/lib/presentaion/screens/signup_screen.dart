import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/screens/login_screen.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/utils/app_colors.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                  hintText: 'Full name',
                  prefixIcon:
                      Icon(Icons.person_2_rounded, color: AppColors.whiteColor),
                ),
                SizedBox(height: 16),
                MyTextField(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email, color: AppColors.whiteColor),
                ),
                SizedBox(height: 16),
                MyTextField(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: AppColors.whiteColor),
                  suffixIcon:
                      Icon(Icons.visibility, color: AppColors.whiteColor),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    elevation: 2,
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  child: Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to the signup screen
                    Navigator.pop(
                      context,
                    );
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
    );
  }
}
