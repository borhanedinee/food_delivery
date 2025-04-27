import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/main.dart';
import 'package:food_delivery/utils/app_colors.dart';

class CustomizeCrepeScreen extends StatelessWidget {
  const CustomizeCrepeScreen({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      padding: EdgeInsets.all(24),
                      height: size.height * 0.4,
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(180),
                          bottomRight: Radius.circular(220),
                        ),
                      ),
                      child: Text(
                        'Customize your crepe',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                      ),
                    ),
                    Positioned(
                      left: size.width * 0.2,
                      bottom: 0,
                      child: Image.network(
                        product.avatar,
                        height: 200,
                        width: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // TOPINGS
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TOPINGS',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildToppingItem(
                          context, 'assets/images/banane.png', 'Banane'),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildToppingItem(
                          context, 'assets/images/fraise.png', 'Fraise'),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildToppingItem(
                          context, 'assets/images/cherry.png', 'Cherry'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // total price
                Text(
                  'Total Price: ${product.price.toInt()} DA',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 10,
              child: ElevatedButton.icon(
                onPressed: () {},
                label: Text('Add To Card'),
                icon: Icon(
                  Icons.shopping_bag,
                  color: AppColors.whiteColor,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  padding: EdgeInsets.all(16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _buildToppingItem(BuildContext context, String asset, String name) {
    return Row(
      children: [
        Image.asset(
          asset,
          height: 30,
          width: 30,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.whiteColor),
        ),
        Spacer(),
        Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ],
    );
  }
}
