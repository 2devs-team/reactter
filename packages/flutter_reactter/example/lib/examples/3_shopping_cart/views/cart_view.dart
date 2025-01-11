// ignore_for_file: avoid_renaming_method_parameters

import 'package:examples/examples/3_shopping_cart/controllers/cart_controller.dart';
import 'package:examples/examples/3_shopping_cart/utils/format_currency.dart';
import 'package:examples/examples/3_shopping_cart/widgets/cart_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CartView extends RtComponent<CartController> {
  const CartView({
    Key? key,
    this.onCheckout,
  }) : super(key: key);

  final VoidCallback? onCheckout;

  @override
  get builder => CartController.new;

  @override
  Widget render(BuildContext context, CartController cartController) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: RtSelector<CartController, int>(
        selector: (inst, watch) => watch(inst.uCartItems).value.length,
        builder: (_, __, itemCount, ____) {
          if (itemCount == 0) {
            return Center(
              child: Text(
                "Your cart is empty!",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: itemCount,
            cacheExtent: 70,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            itemBuilder: (context, index) {
              return RtSelector<CartController, int>(
                selector: (inst, watch) {
                  try {
                    return watch(inst.uCartItems)
                        .value
                        .elementAt(index)
                        .quantity;
                  } catch (e) {
                    return 0;
                  }
                },
                builder: (_, cartController, __, ___) {
                  final item = cartController.uCartItems.value[index];

                  return SizedBox(
                    height: 80,
                    child: CartItemCard(
                      key: ObjectKey(item),
                      cartItem: item,
                      onIncrement: cartController.incrementCartItem,
                      onDecrement: cartController.decrementCartItem,
                      onRemove: cartController.removeCartItem,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: RtWatcher(
        (context, watch) {
          final total = watch(cartController.uTotal).value;
          final isLoading = watch(cartController.uAsyncCart.uIsLoading).value;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: isLoading || total == 0
                  ? null
                  : () {
                      cartController.checkout();
                      onCheckout?.call();
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Builder(builder: (context) {
                  return Row(
                    children: [
                      Text(
                        "Checkout",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      if (isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      else
                        Text(
                          formatCurrency(total),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.grey.shade200),
                        ),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
