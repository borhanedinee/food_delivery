import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/products_controller.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:food_delivery/presentaion/screens/menu_screen.dart';
import 'package:food_delivery/presentaion/screens/product_details_sreen.dart';
import 'package:food_delivery/presentaion/widgets/home_screen/best_product_item.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:food_delivery/utils/dialogs/location_dialog.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

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
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context, screenSize, fontScale),
        body: SizedBox(
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(screenSize, fontScale),
                SizedBox(height: screenSize.height * 0.02),
                GetBuilder<ProductController>(
                  builder: (controller) => controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            _buildMenu(context, screenSize, fontScale),
                            SizedBox(height: screenSize.height * 0.02),
                            _buildPopularProducts(
                                context, screenSize, fontScale),
                            SizedBox(height: screenSize.height * 0.02),
                            _buildBestProducts(context, screenSize, fontScale),
                            SizedBox(height: screenSize.height * 0.08),
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

  AppBar _buildAppBar(BuildContext context, Size screenSize, double fontScale) {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.menu,
          color: Colors.white,
          size: 24 * fontScale,
        ),
      ),
      title: GetBuilder<ProfileController>(
        builder: (controller) => GestureDetector(
          onTap: () => showLocationSearchDialog(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 20 * fontScale,
              ),
              SizedBox(width: screenSize.width * 0.01),
              SizedBox(
                width: screenSize.width * 0.35, // Responsive width
                child: Text(
                  currentUser?.address ?? 'Algiers, Algeria',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: screenSize.width * 0.01),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
                size: 20 * fontScale,
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 24 * fontScale,
          ),
        ),
      ],
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
    );
  }

  Widget _buildSearchBar(Size screenSize, double fontScale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
        vertical: screenSize.height * 0.015,
      ),
      width: screenSize.width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.whiteColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: MyTextField(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          hintText: 'Search products...',
          prefixIcon: Icon(
            LucideIcons.search,
            color: Colors.black,
            size: 20 * fontScale,
          ),
          fillColor: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, Size screenSize, double fontScale) {
    final categories = [
      {'name': 'Crepes', 'image': 'assets/images/crepe_menu.png'},
      {'name': 'Pizzas', 'image': 'assets/images/pizza_menu.png'},
      {'name': 'Juices', 'image': 'assets/images/juice.png'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menu',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * fontScale,
                    ),
              ),
              Text(
                'View all',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12 * fontScale,
                    ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(
                      categoryTitle: category['name']!,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(
                        category['image']!,
                        width: screenSize.width * 0.2, // Responsive size
                        height: screenSize.width * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    Text(
                      category['name']!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14 * fontScale,
                          ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularProducts(
      BuildContext context, Size screenSize, double fontScale) {
    return GetBuilder<ProductController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Products',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * fontScale,
                      ),
                ),
                Text(
                  'View all',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * fontScale,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          SizedBox(
            height: screenSize.height * 0.22, // Smaller height
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
              itemCount: controller.popularProducts.length,
              itemBuilder: (context, index) {
                ProductModel popularProduct = controller.popularProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: popularProduct,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          popularProduct.avatar,
                          width: screenSize.width * 0.5, // Responsive width
                          height: screenSize.height * 0.18,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(width: screenSize.width * 0.02),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestProducts(
      BuildContext context, Size screenSize, double fontScale) {
    final controller = Get.find<ProductController>();
    final bestProducts = controller.allProducts.take(6).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Products',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16 * fontScale,
                    ),
              ),
              Text(
                'View all',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12 * fontScale,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        SizedBox(
          height: screenSize.height * 0.35,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
            itemBuilder: (context, index) {
              ProductModel product = bestProducts[index];
              return SizedBox(
                width: screenSize.width * 0.45,
                child: BestProductItem(product: product),
              );
            },
            separatorBuilder: (context, index) =>
                SizedBox(width: screenSize.width * 0.03),
            itemCount: bestProducts.length,
          ),
        ),
      ],
    );
  }
}
