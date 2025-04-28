import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/data/models/user_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/products_controller.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/presentaion/screens/menu_screen.dart';
import 'package:food_delivery/presentaion/screens/product_details_sreen.dart';
import 'package:food_delivery/presentaion/widgets/home_screen/best_product_item.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/presentaion/widgets/product_card.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/dialogs/location_dialog.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Get.find<ProductController>().fetchAllProducts();
    Get.find<ProductController>().filterPopularProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                SizedBox(
                  height: 20,
                ),
                GetBuilder<ProductController>(
                  builder: (controller) => controller.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            // Menu
                            _buzildMenu(context),
                            const SizedBox(
                              height: 20,
                            ),
                            // Popular Products
                            _buildPopularProducts(context),
                            const SizedBox(
                              height: 20,
                            ),
                            // build best products
                            _buildBestProducts(context),
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildBestProducts(BuildContext context) {
    final controller = Get.find<ProductController>();
    final bestProducts = controller.allProducts.take(6).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Products',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'View all',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.4, // Responsive height
          width: double.infinity, // Full width
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8), // Side padding
            itemBuilder: (context, index) {
              ProductModel product = bestProducts[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.5, // Responsive item width
                child: BestProductItem(product: product),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(width: 12), // Consistent spacing
            itemCount: bestProducts.length,
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      title: GetBuilder<ProfileController>(
        builder: (controller) => GestureDetector(
          onTap: () {
            showLocationSearchDialog(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 150,
                child: Text(
                  currentUser!.address ?? 'Algiers, Algeria',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
      ],
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
    );
  }

  Widget _buildPopularProducts(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Products',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'View all',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.popularProducts.length,
              itemBuilder: (context, index) {
                ProductModel popularProduct = controller.popularProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: popularProduct,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(popularProduct.avatar,
                              width: 220, height: 160, fit: BoxFit.fill),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackColor.withOpacity(.2),
                                blurRadius: 5,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite,
                              )),
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                width: 4,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buzildMenu(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menu',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'View all',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(
                      categoryTitle: 'Crepes',
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/crepe_simple.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Crepes',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(
                      categoryTitle: 'Pizzas',
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/pizza.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Pizzas',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(
                      categoryTitle: 'Juices',
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/juice.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Juices',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 40,
      ),
      // height: 180,
      width: size.width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: (size.width - 40) * .8,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.whiteColor.withOpacity(.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(.2),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: MyTextField(
              hintText: 'Search products...',
              prefixIcon: const Icon(
                LucideIcons.search,
                color: Colors.black,
              ),
              fillColor: AppColors.whiteColor,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.whiteColor.withOpacity(.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(.2),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.slidersHorizontal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
