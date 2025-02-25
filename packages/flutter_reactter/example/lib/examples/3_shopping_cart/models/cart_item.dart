import 'package:examples/examples/3_shopping_cart/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem(this.product, this.quantity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CartItem && product == other.product;

  @override
  int get hashCode => Object.hashAll([product]);

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product ?? this.product,
      quantity ?? this.quantity,
    );
  }
}
