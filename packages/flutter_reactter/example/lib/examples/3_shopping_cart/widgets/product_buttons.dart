import 'package:examples/examples/3_shopping_cart/controllers/product_controller.dart';
import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:examples/examples/3_shopping_cart/widgets/custom_icon_button.dart';
import 'package:examples/examples/3_shopping_cart/widgets/quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class ProductButtons extends StatelessWidget {
  const ProductButtons({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      final productController = context.use<ProductController>("${product.id}");
      final quantity = watch(productController.uQuantity).value;

      if (quantity == 0) {
        return CustomIconButton(
          icon: Icons.add,
          color: Colors.green,
          onPressed: quantity < product.stock
              ? () => productController.addToCart()
              : null,
        );
      }

      return Quantity(
        quantity: quantity,
        maxQuantity: product.stock,
        onDecrement: () => productController.removeFromCart(),
        onIncrement: () => productController.addToCart(),
      );
    });
  }
}
