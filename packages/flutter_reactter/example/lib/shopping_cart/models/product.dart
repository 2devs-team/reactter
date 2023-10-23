class Product {
  final String name;
  final String image;
  final double price;
  final int stock;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.stock,
  });

  Product copyWith({
    String? name,
    String? image,
    double? price,
    int? stock,
  }) =>
      Product(
        name: name ?? this.name,
        image: image ?? this.image,
        price: price ?? this.price,
        stock: stock ?? this.stock,
      );
}
