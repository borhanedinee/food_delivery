import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
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
          child: Stack(
            children: [
              SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 48,
                  children: [
                    Image.asset(
                      'assets/logos/app_logo.png',
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the login screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                        elevation: 2,
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        'Get Started',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: -0,
                bottom: -20,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/crepe.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/juice.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/images/pizza.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
