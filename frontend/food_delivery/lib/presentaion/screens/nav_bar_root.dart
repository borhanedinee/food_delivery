import 'package:flutter/material.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_screens.dart/bag_screen.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_screens.dart/home_screen.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_screens.dart/profile_screen.dart';
import 'package:food_delivery/utils/app_colors.dart';

class NavBarScreen extends StatefulWidget {
  NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag),
      label: 'Bag',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  List<Widget> screens = [
    HomeScreen(),
    BagScreen(),
    ProfileScreen(),
  ];

  int currentIndex = 0;
  // Default to the first screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex], // Default to the first screen
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: currentIndex, // Default to the first item
        onTap: (index) {
          currentIndex = index; // Update the current index
          setState(() {}); // Rebuild the widget to reflect the change
        },
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
