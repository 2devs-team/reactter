import 'package:examples/examples/3_shopping_cart/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class Quantity extends StatelessWidget {
  const Quantity({
    Key? key,
    required this.quantity,
    required this.maxQuantity,
    this.onIncrement,
    this.onDecrement,
  }) : super(key: key);

  final int quantity;
  final int maxQuantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Theme.of(context).highlightColor,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconButton(
            icon: quantity == 1 && onDecrement != null
                ? Icons.delete
                : Icons.remove,
            color: Colors.red,
            onPressed: quantity > 0 ? onDecrement : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("$quantity",
                style: Theme.of(context).textTheme.titleMedium),
          ),
          CustomIconButton(
            icon: Icons.add,
            color: Colors.green,
            onPressed: quantity < maxQuantity ? onIncrement : null,
          ),
        ],
      ),
    );
  }
}
