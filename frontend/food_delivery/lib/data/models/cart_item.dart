import 'package:food_delivery/data/models/product_model.dart';

class CartItem {
  final String productId;
  final int quantity;
  final List<Topping> toppings;
  final String name;
  final double price;
  final String avatar;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.toppings,
    required this.name,
    required this.price,
    required this.avatar,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 1,
      toppings: (json['toppings'] as List<dynamic>?)
              ?.map((item) => Topping.fromJson(item))
              .toList() ??
          [],
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'toppings': toppings.map((t) => t.toJson()).toList(),
      'name': name,
      'price': price,
      'avatar': avatar,
    };
  }
}
