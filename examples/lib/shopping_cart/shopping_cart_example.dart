import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'cart.dart';
import 'contexts/cart_context.dart';
import 'contexts/products_context.dart';
import 'product_item.dart';

class ShoppingCartExample extends StatelessWidget {
  const ShoppingCartExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProviders(
      providers: [
        ReactterProvider(() => ProductsContext()),
        ReactterProvider(() => CartContext()),
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
                        child: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 8,
                          child: ReactterBuilder<CartContext>(
                            listenHooks: (ctx) => [ctx.quantityProducts],
                            builder: (cartCtx, context, child) {
                              return Text(
                                "${cartCtx.quantityProducts.value}",
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
              ),
            ],
          ),
          body: ReactterScope(
            builder: (context, child) {
              final productsCtx = context.watch<ProductsContext>();
              final products = productsCtx.products.value;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductItem(
                    key: ObjectKey(product),
                    product: product,
                    color: index % 2 == 0
                        ? Theme.of(context).hoverColor
                        : Theme.of(context).cardColor,
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
