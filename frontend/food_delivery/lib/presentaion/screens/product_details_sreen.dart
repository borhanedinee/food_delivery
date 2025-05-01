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
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor
    final selectedToppings = <Topping>[].obs; // Track selected toppings

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, screenSize, fontScale),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(context, screenSize),
                _buildDetailsCard(context, screenSize, fontScale),
                _buildToppingsSection(
                    context, screenSize, fontScale, selectedToppings),
                SizedBox(height: screenSize.height * 0.1),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddToCartButton(
          context, screenSize, fontScale, selectedToppings),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  SliverAppBar _buildAppBar(
      BuildContext context, Size screenSize, double fontScale) {
    return SliverAppBar(
      backgroundColor: AppColors.primaryColor,
      expandedHeight: screenSize.height * 0.08, // Smaller height
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 14 * fontScale,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.whiteColor,
          size: 20 * fontScale,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context, Size screenSize) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: screenSize.height * 0.5, // Smaller, responsive height
          width: screenSize.height * 0.8,
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
          bottom: -25,
          left: 0,
          right: 0,
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(
      BuildContext context, Size screenSize, double fontScale) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.02,
      ),
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  fontSize: 18 * fontScale,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenSize.height * 0.01),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 18 * fontScale,
              ),
              SizedBox(width: screenSize.width * 0.01),
              Text(
                product.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                      fontSize: 14 * fontScale,
                    ),
              ),
              SizedBox(width: screenSize.width * 0.04),
              Text(
                '${product.price.toInt()} DA',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      fontSize: 16 * fontScale,
                    ),
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.015),
          Text(
            'Delicious ${product.category.toLowerCase()} made with fresh ingredients. Perfect for a quick meal or a special treat!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12 * fontScale,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildToppingsSection(BuildContext context, Size screenSize,
      double fontScale, RxList<Topping> selectedToppings) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Toppings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  fontSize: 16 * fontScale,
                ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          product.toppings.isEmpty
              ? Center(
                  child: Text(
                    'No toppings available',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12 * fontScale,
                        ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5, // Adjusted for smaller items
                    crossAxisSpacing: screenSize.width * 0.03,
                    mainAxisSpacing: screenSize.height * 0.015,
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
                          screenSize,
                          fontScale,
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
    Size screenSize,
    double fontScale,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.03,
          vertical: screenSize.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Image.network(
              asset,
              height: 20 * fontScale,
              width: 20 * fontScale,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error,
                size: 20 * fontScale,
              ),
            ),
            SizedBox(width: screenSize.width * 0.02),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      fontSize: 12 * fontScale,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle,
              color: AppColors.primaryColor,
              size: 18 * fontScale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, Size screenSize,
      double fontScale, RxList<Topping> selectedToppings) {
    return GetBuilder<CartController>(
      builder: (controller) => Container(
        margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
        width: double.infinity,
        child: controller.isAddingToCardLoading
            ? SizedBox(
                height: 36 * fontScale,
                width: 36 * fontScale,
                child: const Center(child: CircularProgressIndicator()),
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
                icon: Icon(
                  Icons.shopping_bag,
                  color: AppColors.whiteColor,
                  size: 20 * fontScale,
                ),
                label: Text(
                  'Add to Cart',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * fontScale,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.015,
                    horizontal: screenSize.width * 0.04,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
      ),
    );
  }
}
