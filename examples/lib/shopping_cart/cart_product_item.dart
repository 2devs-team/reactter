import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'contexts/cart_context.dart';
import 'contexts/product_context.dart';

class CartProductItem extends ReactterComponent<ProductContext> {
  final ProductContext product;
  final int quantity;
  final Color? color;

  const CartProductItem({
    Key? key,
    required this.product,
    required this.quantity,
    this.color,
  }) : super(key: key);

  @override
  get id => product.hashCode.toString();

  @override
  get builder => () => product;

  @override
  Widget render(ProductContext ctx, BuildContext context) {
    final stock = product.stockState.value;
    final cartCtx = context.read<CartContext>();

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
            onPressed: stock == 0 ? null : () => cartCtx.addProduct(product),
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
