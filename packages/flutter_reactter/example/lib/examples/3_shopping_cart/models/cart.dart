import 'package:examples/examples/3_shopping_cart/models/cart_item.dart';

class Cart {
  final Set<CartItem> items;
  final double total;

  Cart({
    this.items = const {},
    this.total = 0.0,
  });

  Cart copyWith({
    Set<CartItem>? items,
    double? total,
  }) =>
      Cart(
        items: items ?? this.items,
        total: total ?? this.total,
      );
}
