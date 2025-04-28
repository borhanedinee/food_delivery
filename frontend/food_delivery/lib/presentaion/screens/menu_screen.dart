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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(
            'Menu',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: Row(
                children: [
                  // Vertical Categories on the Left
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        )),
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: categories
                          .map((category) => GestureDetector(
                                onTap: () => _onCategoryTap(category),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: RotatedBox(
                                    quarterTurns:
                                        3, // Rotate text 90 degrees counterclockwise
                                    child: AnimatedContainer(
                                      duration: Durations.extralong1,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: selectedCategory == category
                                            ? AppColors.primaryColor
                                                .withValues(alpha: .3)
                                            : null,
                                      ),
                                      child: Text(
                                        category.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedCategory == category
                                              ? AppColors.primaryColor
                                              : Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
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
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                )
                              : buildGridView(controller),
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
          child: const Text(
            'Order',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridView(CategoryProductsController controller) {
    List<ProductModel> products = controller.products;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.5, // Adjusted to match the image
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
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
                prefixIcon: const Icon(
                  LucideIcons.search,
                  color: Colors.black,
                ),
                fillColor: Colors.white,
                onChanged: (value) {
                  // Optional: Add search functionality within the category
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(10),
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
            child: const Icon(
              LucideIcons.slidersHorizontal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
