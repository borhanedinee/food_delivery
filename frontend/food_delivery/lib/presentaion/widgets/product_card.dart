import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/presentaion/screens/customize_crepe.dart';
import 'package:food_delivery/presentaion/screens/product_details_sreen.dart';
import 'package:food_delivery/utils/app_colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fontScale = screenSize.width / 400; // Base scaling factor for fonts

    return GestureDetector(
      onTap: () {
        product.name.toLowerCase() == 'crepe simple'
            ? Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomizeCrepeScreen(product: product),
                ),
              )
            : Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15), // Smaller radius
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  height:
                      screenSize.height * 0.12, // Smaller, responsive height
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      product.avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.005),
                // Product Name and Price
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColors.darkerPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14 * fontScale, // Responsive
                                  ),
                            ),
                            SizedBox(height: screenSize.height * 0.005),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.02,
                                vertical: screenSize.height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${product.price.toInt()} DA',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: AppColors.darkerPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12 * fontScale,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: AppColors.primaryColor,
                        size: 18 * fontScale,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.005),
                // Rating
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryColor,
                        size: 16 * fontScale,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        product.rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.darkerPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12 * fontScale,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Order Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.02,
                    vertical: screenSize.height * 0.005,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.008),
                    ),
                    child: Text(
                      product.name.toLowerCase() == 'crepe simple'
                          ? 'Customize'
                          : 'Order Now',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12 * fontScale,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
