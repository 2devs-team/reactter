// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_shopping_cart/widgets/cart_bottom.dart';
import 'package:examples/examples/4_shopping_cart/widgets/cart_item_card.dart';
import 'package:examples/examples/4_shopping_cart/controllers/cart_controller.dart';

class CartView extends ReactterComponent<CartController> {
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
      body: ReactterSelector<CartController, int>(
        selector: (inst, $) => $(inst.uCartItems).value.length,
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
              return ReactterSelector<CartController, int>(
                selector: (inst, $) {
                  try {
                    return $(inst.uCartItems).value[index].quantity;
                  } catch (e) {
                    return 0;
                  }
                },
                builder: (_, cartController, __, ___) {
                  final item = cartController.uCartItems.value[index];
                  final product = item.product;

                  return SizedBox(
                    height: 80,
                    child: CartItemCard(
                      key: ObjectKey(product),
                      cartItem: item,
                      onAdd: cartController.addProduct,
                      onRemove: cartController.removeProduct,
                      onDelete: cartController.deleteProduct,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: ReactterConsumer<CartController>(
        listenStates: (inst) => [inst.uCartItems],
        builder: (_, cartController, __) {
          final items = cartController.uCartItems.value;
          final itemsCount = cartController.uCartItemsCount.value;
          final total = cartController.uTotal.value;

          return CartBottom(
            productsCount: items.length,
            itemsCount: itemsCount,
            total: total,
            onCheckout: items.isNotEmpty
                ? () {
                    cartController.checkout();
                    onCheckout?.call();
                  }
                : null,
          );
        },
      ),
    );
  }
}
