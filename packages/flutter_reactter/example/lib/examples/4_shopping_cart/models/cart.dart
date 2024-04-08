import 'package:examples/examples/4_shopping_cart/models/cart_item.dart';

class Cart {
  final List<CartItem> items;
  final int itemsCount;
  final double total;

  Cart({
    this.items = const [],
    this.itemsCount = 0,
    this.total = 0.0,
  });
}
