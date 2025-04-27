import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/cart_controller.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final selectedToppings = <Topping>[].obs; // Track selected toppings

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(context),
                _buildDetailsCard(context),
                _buildToppingsSection(context, selectedToppings),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddToCartButton(context, selectedToppings),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primaryColor,
      expandedHeight: 80,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(product.avatar),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) =>
                  const AssetImage('assets/images/placeholder.png'),
            ),
          ),
        ),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                product.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
              ),
              const SizedBox(width: 16),
              Text(
                '${product.price.toInt()} DA',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Delicious ${product.category.toLowerCase()} made with fresh ingredients. Perfect for a quick meal or a special treat!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildToppingsSection(
      BuildContext context, RxList<Topping> selectedToppings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Toppings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
          ),
          const SizedBox(height: 12),
          product.toppings.isEmpty
              ? const Center(child: Text('No toppings available'))
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: product.toppings.length,
                  itemBuilder: (context, index) {
                    final topping = product.toppings[index];
                    return Obx(() => _buildToppingItem(
                          context,
                          topping.asset,
                          topping.name,
                          selectedToppings.contains(topping),
                          () {
                            if (selectedToppings.contains(topping)) {
                              selectedToppings.remove(topping);
                            } else {
                              selectedToppings.add(topping);
                            }
                          },
                        ));
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildToppingItem(
    BuildContext context,
    String asset,
    String name,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Image.network(
              asset,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(
      BuildContext context, RxList<Topping> selectedToppings) {
    return GetBuilder<CartController>(
      builder: (controller) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: controller.isAddingToCardLoading
            ? SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  final userId = currentUser?.uid;
                  if (userId == null) {
                    Get.snackbar('Error', 'Please log in to add to cart');
                    return;
                  }
                  controller.addToCart(
                    userId,
                    product,
                    1, // Default quantity
                    selectedToppings.toList(),
                  );
                },
                icon:
                    const Icon(Icons.shopping_bag, color: AppColors.whiteColor),
                label: Text(
                  'Add to Cart',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
      ),
    );
  }
}
