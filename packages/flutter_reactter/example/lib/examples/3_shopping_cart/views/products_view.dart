// ignore_for_file: avoid_renaming_method_parameters

import 'package:examples/examples/3_shopping_cart/controllers/products_controller.dart';
import 'package:examples/examples/3_shopping_cart/views/cart_view.dart';
import 'package:examples/examples/3_shopping_cart/widgets/cart_action.dart';
import 'package:examples/examples/3_shopping_cart/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class ProductsView extends RtComponent<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  get builder => ProductsController.new;

  @override
  Widget render(BuildContext context, ProductsController productsController) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          RtConsumer<ProductsController>(
            builder: (_, __, ___) {
              return CartAction(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartView(
                        onCheckout: productsController.uAsyncProducts.resolve,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: RtConsumer<ProductsController>(
        listenStates: (inst) => [inst.uAsyncProducts],
        builder: (_, __, ___) {
          return productsController.uAsyncProducts.when(
            idle: (_) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            loading: (_) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            done: (products) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = (constraints.maxWidth / 140).floor();

                  return GridView.count(
                    padding: const EdgeInsets.all(8),
                    crossAxisCount: crossAxisCount.clamp(1, crossAxisCount),
                    childAspectRatio: 9 / 16,
                    children: [
                      for (final product in products)
                        ProductCard(
                          key: ObjectKey(product),
                          product: product,
                        ),
                    ],
                  );
                },
              );
            },
            error: (error) {
              return Center(
                child: Text(error.toString()),
              );
            },
          ) as Widget;
        },
      ),
    );
  }
}
