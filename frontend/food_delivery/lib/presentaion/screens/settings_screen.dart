import 'package:flutter/material.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/presentaion/screens/change_password_screen.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          _buildListTile(
            context,
            leading: Icon(
              Icons.notifications,
              color: AppColors.primaryColor,
            ),
            title: 'Notifications',
            onTap: () {},
          ),
          _buildListTile(
            context,
            leading: Icon(
              Icons.key,
              color: AppColors.primaryColor,
            ),
            title: 'Manage Password',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ),
              );
            },
          ),
          _buildListTile(
            context,
            leading: Icon(
              Icons.delete,
              color: AppColors.primaryColor,
            ),
            title: 'Delete Account',
            onTap: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => GetBuilder<ProfileController>(
                  builder: (controller) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                        'Do you really want to delete your account? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                        },
                        child: const Text('No'),
                      ),
                      GetBuilder<ProfileController>(
                        builder: (controller) => TextButton(
                          onPressed: () async {
                            bool success = await controller.deleteAccount();
                            // Navigation to LoginScreen is handled in deleteAccount
                            if (success) {
                              Navigator.pushAndRemoveUntil(
                                context, // Get the context from GetX
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (Route<dynamic> route) =>
                                    false, // Remove all previous routes
                              );
                            }
                          },
                          child: controller.isDeletingLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('Yes',
                                  style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(
    context, {
    required Widget leading,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryColor,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
