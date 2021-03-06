import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'contexts/cart_context.dart';
import 'contexts/product_context.dart';

class ProductItem extends ReactterComponent<ProductContext> {
  final ProductContext product;
  final Color? color;

  const ProductItem({
    Key? key,
    required this.product,
    this.color,
  }) : super(key: key);

  @override
  get id => "${product.hashCode}";

  @override
  get builder => () => product;

  @override
  Widget render(ProductContext ctx, BuildContext context) {
    final stock = product.stockState.value;
    final cartCtx = context.use<CartContext>();

    return ListTile(
      tileColor: color,
      title: Text(
        product.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: stock == 0
          ? const Text("Sold out")
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('In stock: '),
                Text(
                  "$stock",
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
            formatCurrency(product.price),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          IconButton(
            color: Colors.green.shade400,
            onPressed: stock == 0 ? null : () => cartCtx.addProduct(product),
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
