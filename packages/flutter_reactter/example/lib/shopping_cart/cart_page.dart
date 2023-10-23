// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'widgets/cart_bottom.dart';
import 'widgets/cart_item_card.dart';
import 'controllers/cart_controller.dart';

class CartPage extends ReactterComponent<CartController> {
  const CartPage({
    Key? key,
    this.onCheckout,
  }) : super(key: key);

  final VoidCallback? onCheckout;

  @override
  get builder => CartController.new;

  @override
  Widget render(cartController, context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My cart"),
      ),
      body: ReactterConsumer<CartController>(
        listenStates: (inst) => [
          inst.items,
        ].when(() => inst.items.value.length),
        builder: (_, __, ___) {
          final items = cartController.items.value;

          if (items.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty!",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            cacheExtent: 70,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            itemBuilder: (context, index) {
              final product = items.keys.elementAt(index);

              return ReactterConsumer<CartController>(
                  listenStates: (inst) => [
                        inst.items,
                      ].when(
                        () => inst.items.value[product],
                      ),
                  builder: (cartController, _, __) {
                    final item = items.entries.elementAt(index);

                    return SizedBox(
                      height: 70,
                      child: CartItemCard(
                        key: ObjectKey(product),
                        item: item,
                        onAdd: cartController.addItem,
                        onRemove: cartController.removeItem,
                        onDelete: cartController.deleteItem,
                      ),
                    );
                  });
            },
          );
        },
      ),
      bottomNavigationBar: ReactterConsumer<CartController>(
        listenStates: (inst) => [inst.items],
        builder: (cartController, _, __) {
          final items = cartController.items.value;
          final itemsCount = cartController.itemsCount.value;
          final total = cartController.total.value;

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
