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
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: SizedBox(),
            title: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
          ),
          body: GetBuilder<ProfileController>(
            builder: (controller) => Container(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/rania_avatar.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    currentUser?.name ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                  // profile tiles
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
                                builder: (context) => ManageProfileScreen(),
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
                                builder: (context) => SettingsScreen(),
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
                            size: 30,
                          ),
                          title: tilesInfos[index]['title'],
                          onTap: tilesInfos[index]['onTap'] ?? () {});
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: 3,
                  )
                ],
              ),
            ),
          )),
    );
  }

  ListTile _buildListTile({
    required Widget leading,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryColor,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
