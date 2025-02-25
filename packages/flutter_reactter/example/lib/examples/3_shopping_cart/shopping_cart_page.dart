import 'package:examples/examples/3_shopping_cart/controllers/cart_controller.dart';
import 'package:examples/examples/3_shopping_cart/controllers/products_controller.dart';
import 'package:examples/examples/3_shopping_cart/views/products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtMultiProvider(
      const [
        RtProvider(ProductsController.new),
        RtProvider(CartController.new),
      ],
      builder: (context, child) {
        return const ProductsView();
      },
    );
  }
}
