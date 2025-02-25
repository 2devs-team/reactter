import 'package:examples/examples/3_shopping_cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CartAction extends StatelessWidget {
  const CartAction({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: IconButton(
        onPressed: onPressed,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart, size: 24),
            Positioned(
              top: -8,
              right: -8,
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 8,
                child: RtSelector<CartController, int>(
                  selector: (inst, watch) {
                    return watch(inst.uCartItems).value.length;
                  },
                  builder: (_, cartController, count, __) {
                    return Text(
                      "$count",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.black87),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
