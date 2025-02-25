import 'package:flutter/material.dart';

import 'package:examples/examples/3_shopping_cart/models/cart_item.dart';
import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:examples/examples/3_shopping_cart/utils/format_currency.dart';
import 'package:examples/examples/3_shopping_cart/widgets/custom_icon_button.dart';
import 'package:examples/examples/3_shopping_cart/widgets/product_cover.dart';
import 'package:examples/examples/3_shopping_cart/widgets/quantity.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final void Function(CartItem cartItem)? onIncrement;
  final void Function(CartItem cartItem)? onDecrement;
  final void Function(CartItem cartItem)? onRemove;

  const CartItemCard({
    Key? key,
    required this.cartItem,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  }) : super(key: key);

  Product get product => cartItem.product;
  int get quantity => cartItem.quantity;
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
            child: ProductCover(index: product.id),
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
                        onDecrement: quantity > 1
                            ? () => onDecrement?.call(cartItem)
                            : null,
                        onIncrement: () => onIncrement?.call(cartItem),
                      ),
                      const SizedBox(width: 8),
                      CustomIconButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onPressed: () => onRemove?.call(cartItem),
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
