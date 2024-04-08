import 'package:examples/examples/4_shopping_cart/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem(this.product, this.quantity);

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
