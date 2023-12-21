import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'custom_icon_button.dart';
import 'quantity.dart';

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
      (inst, $) => inst.uItems.value[product] ?? 0,
    );

    if (quantity == 0) {
      return CustomIconButton(
        icon: Icons.add,
        color: Colors.green,
        onPressed: quantity < product.stock
            ? () => cartController.addItem(product)
            : null,
      );
    }

    return Quantity(
      quantity: quantity,
      maxQuantity: product.stock,
      onRemove: () => cartController.removeItem(product),
      onAdd: () => cartController.addItem(product),
    );
  }
}
