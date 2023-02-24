import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'contexts/cart_context.dart';
import 'models/product_state.dart';

class CartProductItem extends StatelessWidget {
  final ProductState product;
  final int quantity;
  final Color? color;

  const CartProductItem({
    Key? key,
    required this.product,
    required this.quantity,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartCtx = context.use<CartContext>();

    return ListTile(
      tileColor: color,
      title: Text(
        product.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Price: '),
          Text(
            formatCurrency(product.price),
            style: Theme.of(context).textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatCurrency(product.price * quantity),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          Text(
            "x$quantity",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => cartCtx.deleteProduct(product),
            color: Colors.red.shade400,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => cartCtx.removeProduct(product),
            color: Colors.red.shade400,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.remove_circle),
          ),
          IconButton(
            onPressed:
                product.stock == 0 ? null : () => cartCtx.addProduct(product),
            color: Colors.green.shade400,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
    );
  }
}
