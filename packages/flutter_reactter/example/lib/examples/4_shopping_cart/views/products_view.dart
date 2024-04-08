// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_shopping_cart/controllers/products_controller.dart';
import 'package:examples/examples/4_shopping_cart/views/cart_view.dart';
import 'package:examples/examples/4_shopping_cart/widgets/cart_action.dart';
import 'package:examples/examples/4_shopping_cart/widgets/product_card.dart';

class ProductsView extends ReactterComponent<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  get builder => ProductsController.new;

  @override
  Widget render(BuildContext context, ProductsController productsController) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          ReactterConsumer<ProductsController>(
            builder: (_, __, ___) {
              return CartAction(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartView(
                        onCheckout: productsController.uProducts.refresh,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = (constraints.maxWidth / 140).floor();

          return ReactterConsumer<ProductsController>(
            listenStates: (inst) => [inst.uProducts],
            builder: (_, __, ___) {
              final products = productsController.uProducts.value;

              return GridView.count(
                padding: const EdgeInsets.all(8),
                crossAxisCount: crossAxisCount.clamp(1, crossAxisCount),
                childAspectRatio: 9 / 16,
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
        },
      ),
    );
  }
}
