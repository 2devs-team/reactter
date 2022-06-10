import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'cart.dart';
import 'cart_context.dart';
import 'product_item.dart';
import 'products_context.dart';

class ShoppingCartExample extends StatelessWidget {
  const ShoppingCartExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => ProductsContext()),
        UseContext(() => CartContext()),
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Shopping cart"),
            actions: [
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                  width: kToolbarHeight,
                ),
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cart(),
                    ),
                  ),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart, size: 24),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: ReactterBuilder<CartContext>(
                          listenHooks: (ctx) => [ctx.quantityProducts],
                          builder: (cartCtx, context, child) {
                            return CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 8,
                              child: Text(
                                cartCtx.quantityProducts.value.toString(),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: ReactterBuilder<ProductsContext>(
            builder: (productsCtx, context, child) {
              final products = productsCtx.products.value;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductItem(
                    key: ObjectKey(product),
                    product: product,
                    color: index % 2 == 0
                        ? Colors.grey.shade50
                        : Colors.grey.shade200,
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
