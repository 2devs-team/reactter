class Product {
  final String name;
  final double price;
  final int stock;

  Product({
    required this.name,
    required this.price,
    required this.stock,
  });

  Product copyWith({
    String? name,
    double? price,
    int? stock,
  }) =>
      Product(
        name: name ?? this.name,
        price: price ?? this.price,
        stock: stock ?? this.stock,
      );
}
