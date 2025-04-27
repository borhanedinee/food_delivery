import 'package:food_delivery/data/models/product_model.dart';
import 'package:food_delivery/presentaion/controllers/products_controller.dart';
import 'package:get/get.dart';

class CategoryProductsController extends GetxController {
  final controller = Get.find<ProductController>();

  List<ProductModel> products = [];
  bool isLoading = false;

  fetchFilteredProducts(String category) {
    try {
      isLoading = true;
      update();

      products = controller.filterProductsByCategory(category);
    } on Object catch (error, stackTrace) {
      Get.snackbar('Error', 'Error fetching category products');
    } finally {
      isLoading = false;
      update();
    }
  }
}
