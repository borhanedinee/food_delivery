import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/presentaion/screens/change_password_screen.dart';
import 'package:food_delivery/presentaion/screens/pre_screens/login_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16 * fontScale,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.03),
              _buildListTile(
                context,
                leading: Icon(
                  Icons.notifications,
                  color: AppColors.primaryColor,
                  size: 24 * fontScale,
                ),
                title: 'Notifications',
                onTap: () {},
                fontScale: fontScale,
              ),
              Divider(
                height: screenSize.height * 0.01,
                thickness: 1,
                color: Colors.grey[300],
              ),
              _buildListTile(
                context,
                leading: Icon(
                  Icons.key,
                  color: AppColors.primaryColor,
                  size: 24 * fontScale,
                ),
                title: 'Manage Password',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
                fontScale: fontScale,
              ),
              Divider(
                height: screenSize.height * 0.01,
                thickness: 1,
                color: Colors.grey[300],
              ),
              _buildListTile(
                context,
                leading: Icon(
                  Icons.delete,
                  color: AppColors.primaryColor,
                  size: 24 * fontScale,
                ),
                title: 'Delete Account',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => GetBuilder<ProfileController>(
                      builder: (controller) => AlertDialog(
                        title: Text(
                          'Delete Account',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 16 * fontScale,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        content: Text(
                          'Do you really want to delete your account? This action cannot be undone.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 12 * fontScale,
                                  ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                            },
                            child: Text(
                              'No',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 12 * fontScale,
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                          ),
                          GetBuilder<ProfileController>(
                            builder: (controller) => TextButton(
                              onPressed: () async {
                                bool success = await controller.deleteAccount();
                                if (success) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              },
                              child: controller.isDeletingLoading
                                  ? SizedBox(
                                      width: 20 * fontScale,
                                      height: 20 * fontScale,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Yes',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontSize: 12 * fontScale,
                                            color: Colors.red,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                fontScale: fontScale,
              ),
              SizedBox(height: screenSize.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required Widget leading,
    required String title,
    required VoidCallback onTap,
    required double fontScale,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 14 * fontScale,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryColor,
        size: 16 * fontScale,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: size.height * 0.01,
      ),
      onTap: onTap,
    );
  }
}
