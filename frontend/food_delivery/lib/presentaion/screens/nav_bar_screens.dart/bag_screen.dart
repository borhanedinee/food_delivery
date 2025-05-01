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
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16 * fontScale,
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
                        padding: EdgeInsets.only(top: screenSize.height * 0.2),
                        child: Text(
                          'Your cart is empty',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: 16 * fontScale,
                                  ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCartItems(
                          context,
                          cartController,
                          currentUser?.uid,
                          screenSize,
                          fontScale,
                        ),
                        _buildTotalAndUserInfoBox(
                          context,
                          cartController,
                          currentUser,
                          screenSize,
                          fontScale,
                        ),
                        SizedBox(
                            height: screenSize.height *
                                0.12), // Space for checkout button
                      ],
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCheckoutButton(
        context,
        cartController,
        currentUser?.uid,
        screenSize,
        fontScale,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCartItems(
    BuildContext context,
    CartController cartController,
    String? userId,
    Size screenSize,
    double fontScale,
  ) {
    return Container(
      margin: EdgeInsets.all(screenSize.width * 0.04),
      child: GetBuilder<CartController>(
        builder: (controller) => Column(
          children: controller.cartItems
              .asMap()
              .entries
              .map((entry) => _buildCartItemCard(
                    context,
                    controller,
                    userId,
                    entry.value,
                    screenSize,
                    fontScale,
                  ))
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
    Size screenSize,
    double fontScale,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.015),
      padding: EdgeInsets.all(screenSize.width * 0.03),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.avatar,
              width: screenSize.width * 0.18, // Smaller, responsive size
              height: screenSize.width * 0.18,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: screenSize.width * 0.18,
                height: screenSize.width * 0.18,
                color: Colors.grey[300],
                child: Icon(
                  Icons.broken_image,
                  size: 30 * fontScale,
                ),
              ),
            ),
          ),
          SizedBox(width: screenSize.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                        fontSize: 14 * fontScale,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenSize.height * 0.005),
                Text(
                  '${item.price.toInt()} DA',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * fontScale,
                      ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: AppColors.primaryColor,
                        size: 20 * fontScale,
                      ),
                      onPressed: () {
                        if (userId != null) {
                          cartController.updateQuantity(
                              userId, item.productId, item.quantity - 1);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Text(
                      item.quantity.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                            fontSize: 14 * fontScale,
                          ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: AppColors.primaryColor,
                        size: 20 * fontScale,
                      ),
                      onPressed: () {
                        if (userId != null) {
                          cartController.updateQuantity(
                              userId, item.productId, item.quantity + 1);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red[400],
              size: 20 * fontScale,
            ),
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
    BuildContext context,
    CartController cartController,
    UserModel? user,
    Size screenSize,
    double fontScale,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.01,
      ),
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.red[900], // Deep red background
        borderRadius: BorderRadius.circular(12),
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
                padding: EdgeInsets.all(screenSize.width * 0.02),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user != null ? user.name.toUpperCase() : 'GUEST',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                            fontSize: 14 * fontScale,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user != null
                          ? 'Home Location ${user.address}'
                          : 'Not logged in',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 12 * fontScale,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(color: Colors.red, thickness: 1),
                    Text(
                      'Wonder food location SIDI YAHIA',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 12 * fontScale,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              // Total Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUBTOTAL',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                        ),
                  ),
                  Text(
                    '${subtotal.toInt()} DA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                        ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                        ),
                  ),
                  Text(
                    '${delivery.toInt()} DA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                        ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reward points',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 * fontScale,
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.02,
                      vertical: screenSize.height * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '0 points',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 12 * fontScale,
                          ),
                    ),
                  ),
                ],
              ),
              Divider(color: AppColors.whiteColor, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * fontScale,
                        ),
                  ),
                  Text(
                    '${total.toInt()} DA',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * fontScale,
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
    BuildContext context,
    CartController cartController,
    String? userId,
    Size screenSize,
    double fontScale,
  ) {
    return GetBuilder<CartController>(
      builder: (controller) => Container(
        height: screenSize.height * 0.06, // Smaller height
        margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
        width: double.infinity,
        child: controller.isPlacingOrderLoading
            ? Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: () {
                  if (userId == null) {
                    Get.snackbar('Error', 'Please log in to checkout');
                    return;
                  }
                  if (cartController.cartItems.isEmpty) return;
                  cartController.placeOrder(userId);
                },
                icon: Icon(
                  Icons.check_circle,
                  color: AppColors.whiteColor,
                  size: 20 * fontScale,
                ),
                label: Text(
                  'Checkout',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * fontScale,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cartController.cartItems.isEmpty
                      ? Colors.grey
                      : AppColors.primaryColor,
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
