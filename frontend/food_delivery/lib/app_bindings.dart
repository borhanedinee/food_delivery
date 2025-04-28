import 'package:food_delivery/presentaion/controllers/auth_controller.dart';
import 'package:food_delivery/presentaion/controllers/cart_controller.dart';
import 'package:food_delivery/presentaion/controllers/category_products_controller.dart';
import 'package:food_delivery/presentaion/controllers/products_controller.dart';
import 'package:food_delivery/presentaion/controllers/profile_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CategoryProductsController(),
      fenix: true,
    );

    Get.lazyPut(
      () => AuthController(),
      fenix: true,
    );
    Get.lazyPut(
      () => ProductController(),
      fenix: true,
    );
    Get.lazyPut(
      () => CartController(),
      fenix: true,
    );
    Get.lazyPut(
      () => ProfileController(),
      fenix: true,
    );
  }
}
