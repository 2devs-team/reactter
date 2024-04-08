import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_shopping_cart/controllers/cart_controller.dart';
import 'package:examples/examples/4_shopping_cart/models/product.dart';
import 'package:examples/examples/4_shopping_cart/widgets/custom_icon_button.dart';
import 'package:examples/examples/4_shopping_cart/widgets/quantity.dart';

class ProductButtons extends StatelessWidget {
  const ProductButtons({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cartController = context.use<CartController>();
    final quantity = context.select<CartController, int>(
      (inst, $) => inst.getProductQuantity(product),
    );

    if (quantity == 0) {
      return CustomIconButton(
        icon: Icons.add,
        color: Colors.green,
        onPressed: quantity < product.stock
            ? () => cartController.addProduct(product)
            : null,
      );
    }

    return Quantity(
      quantity: quantity,
      maxQuantity: product.stock,
      onRemove: () => cartController.removeProduct(product),
      onAdd: () => cartController.addProduct(product),
    );
  }
}
