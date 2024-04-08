import 'package:flutter/material.dart';

import 'package:examples/examples/4_shopping_cart/widgets/custom_icon_button.dart';

class Quantity extends StatelessWidget {
  const Quantity({
    Key? key,
    required this.quantity,
    required this.maxQuantity,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  final int quantity;
  final int maxQuantity;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: Colors.black38,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            icon: quantity == 1 ? Icons.delete : Icons.remove,
            color: Colors.red,
            onPressed: quantity > 0 ? onRemove : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "$quantity",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
          CustomIconButton(
            icon: Icons.add,
            color: Colors.green,
            onPressed: quantity < maxQuantity ? onAdd : null,
          ),
        ],
      ),
    );
  }
}
