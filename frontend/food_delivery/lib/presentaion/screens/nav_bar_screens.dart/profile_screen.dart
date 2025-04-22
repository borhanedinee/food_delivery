import 'package:flutter/material.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/utils/app_colors.dart';

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
          body: Container(
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
                const Text(
                  'Rania Alsharif',
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
                      },
                      {
                        'icon': Icons.location_on,
                        'title': 'My Address',
                      },
                      {
                        'icon': Icons.settings,
                        'title': 'Settings',
                      },
                      {
                        'icon': Icons.logout,
                        'title': 'Logout',
                      },
                    ];

                    return _buildListTile(
                        leading: Icon(
                          tilesInfos[index]['icon'],
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                        title: tilesInfos[index]['title'],
                        onTap: () {});
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: 4,
                )
              ],
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
