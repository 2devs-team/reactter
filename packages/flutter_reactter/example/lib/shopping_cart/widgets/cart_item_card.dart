import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/format_currency.dart';
import 'custom_icon_button.dart';
import 'quantity.dart';

class CartItemCard extends StatelessWidget {
  final MapEntry<Product, int> item;
  final void Function(Product product)? onAdd;
  final void Function(Product product)? onRemove;
  final void Function(Product product)? onDelete;

  const CartItemCard({
    Key? key,
    required this.item,
    this.onAdd,
    this.onRemove,
    this.onDelete,
  }) : super(key: key);

  Product get product => item.key;
  int get quantity => item.value;
  double get total => product.price * quantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(product.image),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FittedBox(
                          child: _buildPriceInfo(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Quantity(
                        quantity: quantity,
                        maxQuantity: product.stock,
                        onRemove: () => onRemove?.call(product),
                        onAdd: () => onAdd?.call(product),
                      ),
                      const SizedBox(width: 8),
                      CustomIconButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onPressed: () => onDelete?.call(product),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Price: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              formatCurrency(product.price),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              formatCurrency(total),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
