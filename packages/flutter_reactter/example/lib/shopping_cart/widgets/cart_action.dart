import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../cart_page.dart';
import '../controllers/cart_controller.dart';

class CartAction extends StatelessWidget {
  const CartAction({
    Key? key,
    this.onCheckout,
  }) : super(key: key);

  final VoidCallback? onCheckout;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(
              onCheckout: onCheckout,
            ),
          ),
        ),
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
                child: ReactterConsumer<CartController>(
                  listenStates: (inst) => [inst.uItemsCount],
                  builder: (cartController, _, __) {
                    return Text(
                      "${cartController.uItemsCount.value}",
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
