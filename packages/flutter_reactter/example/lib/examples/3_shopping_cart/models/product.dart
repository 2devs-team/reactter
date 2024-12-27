class Product {
  final int id;
  final String name;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  Product copyWith({
    int? id,
    String? name,
    String? image,
    double? price,
    int? stock,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        stock: stock ?? this.stock,
      );
}
