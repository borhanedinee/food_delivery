import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/user_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/auth_controller.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/presentaion/screens/manage_profile_screen.dart';
import 'package:food_delivery/presentaion/screens/settings_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                  fontSize: 16 * fontScale,
                ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
        ),
        body: GetBuilder<ProfileController>(
          builder: (controller) => Container(
            width: screenSize.width,
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(screenSize.width * 0.005),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screenSize.width * 0.1),
                    child: Image.asset(
                      'assets/images/rania_avatar.png',
                      width: screenSize.width * 0.2, // Smaller, responsive size
                      height: screenSize.width * 0.2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: screenSize.width * 0.2,
                        height: screenSize.width * 0.2,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          size: 30 * fontScale,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.015),
                Text(
                  currentUser?.name ?? 'Guest',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * fontScale,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenSize.height * 0.05),
                // Profile tiles
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List<Map> tilesInfos = [
                      {
                        'icon': Icons.person,
                        'title': 'My Profile',
                        'onTap': () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ManageProfileScreen(),
                            ),
                          );
                        }
                      },
                      {
                        'icon': Icons.settings,
                        'title': 'Settings',
                        'onTap': () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        }
                      },
                      {
                        'icon': Icons.logout,
                        'title': 'Logout',
                        'onTap': () {
                          Get.find<AuthController>().logout();
                        },
                      },
                    ];

                    return _buildListTile(
                      leading: Icon(
                        tilesInfos[index]['icon'],
                        color: AppColors.primaryColor,
                        size: 24 * fontScale,
                      ),
                      title: tilesInfos[index]['title'],
                      onTap: tilesInfos[index]['onTap'] ?? () {},
                      context: context,
                      fontScale: fontScale,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: screenSize.height * 0.01,
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  itemCount: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required Widget leading,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
    required double fontScale,
  }) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14 * fontScale,
              fontWeight: FontWeight.w600,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryColor,
        size: 16 * fontScale,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
    );
  }
}
