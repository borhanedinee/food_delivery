import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/cart_item.dart';
import 'package:food_delivery/data/models/user_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/presentaion/controllers/auth_controller.dart';
import 'package:food_delivery/presentaion/controllers/cart_controller.dart';
import 'package:food_delivery/utils/app_colors.dart';
import 'package:get/get.dart';

class BagScreen extends StatelessWidget {
  const BagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<CartController>(
          builder: (controller) => Column(
            children: [
              controller.cartItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: Text(
                          'Your cart is empty',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCartItems(
                            context, cartController, currentUser?.uid),
                        _buildTotalAndUserInfoBox(
                            context, cartController, currentUser),
                        const SizedBox(
                            height: 100), // Space for checkout button
                      ],
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          _buildCheckoutButton(context, cartController, currentUser?.uid),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCartItems(
      BuildContext context, CartController cartController, String? userId) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GetBuilder<CartController>(
        builder: (controller) => Column(
          children: controller.cartItems
              .asMap()
              .entries
              .map((entry) =>
                  _buildCartItemCard(context, controller, userId, entry.value))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    CartController cartController,
    String? userId,
    CartItem item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.avatar,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toInt()} DA',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle,
                          color: AppColors.primaryColor),
                      onPressed: () {
                        if (userId != null) {
                          cartController.updateQuantity(
                              userId, item.productId, item.quantity - 1);
                        }
                      },
                    ),
                    Text(
                      item.quantity.toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.add_circle, color: AppColors.primaryColor),
                      onPressed: () {
                        if (userId != null) {
                          cartController.updateQuantity(
                              userId, item.productId, item.quantity + 1);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red[400]),
            onPressed: () {
              if (userId != null) {
                cartController.removeItem(userId, item.productId);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAndUserInfoBox(
      BuildContext context, CartController cartController, UserModel? user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[900], // Deep red background as in image
        borderRadius: BorderRadius.circular(16),
      ),
      child: GetBuilder<CartController>(
        builder: (controller) {
          final subtotal = controller.cartItems
              .fold(0.0, (sum, item) => sum + item.price * item.quantity);
          const delivery = 300.0; // Fixed delivery price
          final total = subtotal + delivery;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user != null ? user.name.toUpperCase() : 'GUEST',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                    ),
                    Text(
                      user != null
                          ? 'Home Location ${user.address}'
                          : 'Not logged in',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackColor,
                          ),
                    ),
                    const Divider(color: Colors.red, thickness: 1),
                    Text(
                      'Wonder food location SIDI YAHIA',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackColor,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Total Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUBTOTAL',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${subtotal.toInt()} DA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${delivery.toInt()} DA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reward points',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '0 points',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackColor,
                          ),
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.whiteColor, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${total.toInt()} DA',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutButton(
      BuildContext context, CartController cartController, String? userId) {
    return GetBuilder<CartController>(
      builder: (controller) => Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: controller.isPlacingOrderLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton.icon(
                onPressed: () {
                  if (userId == null) {
                    Get.snackbar('Error', 'Please log in to checkout');
                    return;
                  }
                  if (cartController.cartItems.isEmpty) return;
                  cartController.placeOrder(userId);
                },
                icon:
                    const Icon(Icons.check_circle, color: AppColors.whiteColor),
                label: Text(
                  'Checkout',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cartController.cartItems.isEmpty
                      ? Colors.grey
                      : AppColors.primaryColor,
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
