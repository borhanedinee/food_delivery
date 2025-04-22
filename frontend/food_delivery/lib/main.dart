import 'package:flutter/material.dart';
import 'package:food_delivery/presentaion/screens/get_started_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

late Size size;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GetMaterialApp(
      title: 'Wonder Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GetStartedScreen(),
    );
  }
}
