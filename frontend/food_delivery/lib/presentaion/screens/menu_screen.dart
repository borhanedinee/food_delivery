import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/presentaion/controllers/category_products_controller.dart';
import 'package:food_delivery/presentaion/screens/nav_bar_screens.dart/bag_screen.dart';
import 'package:food_delivery/presentaion/widgets/my_text_field.dart';
import 'package:food_delivery/presentaion/widgets/product_card.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, required this.categoryTitle});

  final String categoryTitle;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CategoryProductsController controller =
      Get.find<CategoryProductsController>();
  final List<String> categories = ['Crepes', 'Pizzas', 'Juices'];
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryTitle;
    controller.fetchFilteredProducts(selectedCategory);
  }

  void _onCategoryTap(String category) {
    setState(() {
      selectedCategory = category;
    });
    controller.fetchFilteredProducts(category);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Menu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.05, // Responsive font size
                ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildSearchBar(context, screenSize),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical Categories on the Left
                  SingleChildScrollView(
                    child: Container(
                      height: screenSize.height * .7,
                      width: screenSize.width * 0.1, // Responsive width
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: categories
                                .map((category) => GestureDetector(
                                      onTap: () => _onCategoryTap(category),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenSize.height * 0.02,
                                        ),
                                        child: RotatedBox(
                                          quarterTurns: 3,
                                          child: AnimatedContainer(
                                            duration: Durations.extralong1,
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.width * 0.04,
                                              vertical:
                                                  screenSize.height * 0.005,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: selectedCategory ==
                                                      category
                                                  ? AppColors.primaryColor
                                                      .withValues(alpha: 0.3)
                                                  : null,
                                            ),
                                            child: Text(
                                              category.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    selectedCategory == category
                                                        ? AppColors.primaryColor
                                                        : Colors.black,
                                                fontSize: screenSize.width *
                                                    0.028, // Responsive
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  // Product Grid on the Right
                  Expanded(
                    child: GetBuilder<CategoryProductsController>(
                      builder: (controller) => controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : controller.products.isEmpty
                              ? Center(
                                  child: Text(
                                    '$selectedCategory Products is empty',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: screenSize.width * 0.04,
                                        ),
                                  ),
                                )
                              : buildGridView(controller, screenSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const BagScreen());
          },
          backgroundColor: AppColors.primaryColor,
          child: Text(
            'Order',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.width * 0.04, // Responsive
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(CategoryProductsController controller, Size screenSize) {
    List<ProductModel> products = controller.products;

    return GridView.builder(
      padding: EdgeInsets.all(screenSize.width * 0.03),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: screenSize.width * 0.03,
        mainAxisSpacing: screenSize.width * 0.03,
        childAspectRatio: 0.6, // Adjusted for smaller ProductCard
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, Size screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.01,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MyTextField(
          hintText: 'Search',
          prefixIcon: Icon(
            LucideIcons.search,
            color: Colors.black,
            size: screenSize.width * 0.06, // Responsive icon size
          ),
          fillColor: Colors.white,
          onChanged: (value) {
            // Optional: Add search functionality within the category
          },
        ),
      ),
    );
  }
}
