import 'package:examples/shopping_cart/widgets/quantity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'custom_icon_button.dart';

class ProductButtons extends StatelessWidget {
  const ProductButtons({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ReactterConsumer<CartController>(
      listenStates: (inst) => [
        inst.items,
      ].when(() => inst.getQuantity(product)),
      builder: (cartController, _, __) {
        final quantity = cartController.getQuantity(product);

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
      },
    );
  }
}
