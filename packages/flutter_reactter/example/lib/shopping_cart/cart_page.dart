import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'cart_product_item.dart';
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
      body: Builder(
        builder: (context) {
          context.watch<CartController>((inst) => [inst.products]);

          final products = cartController.products.value;

          return products.isEmpty
              ? Center(
                  child: Text(
                    "Your cart is empty!",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : ListView.builder(
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
      bottomNavigationBar: Builder(
        builder: (context) {
          context.watch<CartController>(
            (inst) => [inst.total, inst.quantityProducts],
          );

          final products = cartController.products.value;
          final quantityProducts = cartController.quantityProducts.value;
          final total = cartController.total.value;

          return BottomSheet(
            onClosing: () {},
            elevation: 16,
            enableDrag: false,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Total(x$quantityProducts): ",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          formatCurrency(total),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          products.isNotEmpty ? cartController.checkout : null,
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
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
