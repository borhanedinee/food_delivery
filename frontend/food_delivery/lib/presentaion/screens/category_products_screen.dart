import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/presentaion/controllers/category_products_controller.dart';
import 'package:food_delivery/presentaion/widgets/product_card.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.categoryTitle});

  final String categoryTitle;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Get.find<CategoryProductsController>()
        .fetchFilteredProducts(widget.categoryTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: GetBuilder<CategoryProductsController>(
        builder: (controller) => controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : controller.products.isEmpty
                ? Center(
                    child: Text(
                      '${widget.categoryTitle} Products is empty',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : buildGridView(controller),
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
        childAspectRatio: .5, // Adjust this to fit your card height
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}
