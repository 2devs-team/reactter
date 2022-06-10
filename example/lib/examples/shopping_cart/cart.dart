import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'cart_context.dart';
import 'cart_product_item.dart';
import 'product_context.dart';

class Cart extends ReactterComponent<CartContext> {
  const Cart({Key? key}) : super(key: key);

  @override
  get builder => () => CartContext();

  @override
  Widget render(ctx, context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => CartContext()),
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My cart"),
          ),
          body: ReactterBuilder<CartContext>(
            listenHooks: (ctx) => [ctx.productsLen],
            builder: (cartCtx, context, child) {
              final products = cartCtx.products.value;

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
                              ? Colors.grey.shade50
                              : Colors.grey.shade200,
                        );
                      },
                    );
            },
          ),
          bottomNavigationBar: ReactterBuilder<CartContext>(
            listenHooks: (ctx) => [ctx.total, ctx.quantityProducts],
            builder: (cartCtx, context, child) {
              final products = cartCtx.products.value;
              final quantityProducts = cartCtx.quantityProducts.value;
              final total = cartCtx.total.value;

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
                              products.isNotEmpty ? cartCtx.checkout : null,
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
      },
    );
  }
}
