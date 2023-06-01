import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'controllers/cart_controller.dart';
import 'models/product_state.dart';

class ProductItem extends StatelessWidget {
  final ProductState product;
  final Color? color;

  const ProductItem({
    Key? key,
    required this.product,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartController = context.use<CartController>();

    return ListTile(
      tileColor: color,
      title: Text(
        product.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: product.stock == 0
          ? const Text("Sold out")
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('In stock: '),
                Text(
                  "${product.stock}",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formatCurrency(product.price),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          IconButton(
            color: Colors.green.shade400,
            onPressed: product.stock == 0
                ? null
                : () => cartController.addProduct(product),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}
