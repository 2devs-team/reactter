import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'controllers/cart_controller.dart';
import 'controllers/products_controller.dart';
import 'widgets/cart_action.dart';
import 'widgets/product_card.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProviders(
      const [
        ReactterProvider(ProductsController.new),
        ReactterProvider(CartController.new),
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Shopping cart"),
            actions: [
              ReactterConsumer<ProductsController>(
                builder: (productsController, _, __) {
                  return CartAction(
                    onCheckout: productsController.loadProducts,
                  );
                },
              ),
            ],
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return ReactterConsumer<ProductsController>(
              listenStates: (inst) => [
                inst.products,
              ],
              builder: (productsController, _, __) {
                final products = productsController.products.value;
                final crossAxisCount = (constraints.maxWidth / 140).floor();

                return GridView.count(
                  padding: const EdgeInsets.all(8),
                  crossAxisCount: crossAxisCount.clamp(1, crossAxisCount),
                  childAspectRatio: 9 / 15,
                  children: [
                    for (final product in products)
                      ProductCard(
                        key: ObjectKey(product),
                        product: product,
                      )
                  ],
                );
              },
            );
          }),
        );
      },
    );
  }
}
