// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'widgets/cart_product_item.dart';
import 'controllers/cart_controller.dart';
import 'models/product_state.dart';

class CartPage extends ReactterComponent<CartController> {
  const CartPage({Key? key}) : super(key: key);

  @override
  get builder => () => CartController();

  @override
  Widget render(cartController, context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My cart"),
      ),
      body: ReactterConsumer<CartController>(
        listenStates: (inst) => [inst.products],
        builder: (_, __, ___) {
          final products = cartController.products.value;

          if (products.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty!",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products.keys.elementAt(index);
              final quantity = products.values.elementAt(index);

              return CartProductItem(
                key: ObjectKey(product),
                product: product,
                quantity: quantity,
                color: index % 2 == 0
                    ? Theme.of(context).hoverColor
                    : Theme.of(context).cardColor,
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomSheet(
        onClosing: () {},
        elevation: 16,
        enableDrag: false,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ReactterConsumer<CartController>(
                      listenStates: (inst) => [inst.quantityProducts],
                      builder: (_, __, ___) {
                        final quantityProducts =
                            cartController.quantityProducts.value;

                        return Text(
                          "Total(x$quantityProducts): ",
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      },
                    ),
                    ReactterConsumer<CartController>(
                      listenStates: (inst) => [inst.total],
                      builder: (_, __, ___) {
                        final total = cartController.total.value;

                        return Text(
                          formatCurrency(total),
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ReactterConsumer<CartController>(
                  listenStates: (inst) => [inst.products],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Checkout",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  builder: (_, __, child) {
                    final products = cartController.products.value;

                    return ElevatedButton(
                      onPressed:
                          products.isNotEmpty ? cartController.checkout : null,
                      child: child,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
