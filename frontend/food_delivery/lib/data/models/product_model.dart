class ProductModel {
  final String id;
  final String name;
  final double price;
  final String avatar;
  final double rating;
  final String category;
  final List<Topping> toppings; // Added for dynamic toppings

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.avatar,
    required this.rating,
    required this.category,
    required this.toppings,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      avatar: json['avatar'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] ?? '',
      toppings: (json['toppings'] as List<dynamic>?)
              ?.map((item) => Topping.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'avatar': avatar,
      'rating': rating,
      'category': category,
      'toppings': toppings.map((topping) => topping.toJson()).toList(),
    };
  }
}

class Topping {
  final String name;
  final String asset;

  Topping({required this.name, required this.asset});

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      name: json['name'] ?? '',
      asset: json['asset'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'asset': asset,
    };
  }
}
