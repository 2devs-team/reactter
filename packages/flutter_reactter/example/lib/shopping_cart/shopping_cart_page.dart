import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'cart_page.dart';
import 'controllers/cart_controller.dart';
import 'controllers/products_controller.dart';
import 'widgets/product_item.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProviders(
      [
        ReactterProvider(() => ProductsController()),
        ReactterProvider(() => CartController()),
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
                      builder: (context) => const CartPage(),
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
                          child: ReactterConsumer<CartController>(
                            listenStates: (inst) => [inst.quantityProducts],
                            builder: (cartController, _, __) {
                              return Text(
                                "${cartController.quantityProducts.value}",
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
          body: ReactterConsumer<ProductsController>(
            listenStates: (inst) => [inst.products],
            builder: (productsController, _, __) {
              final products = productsController.products.value;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return ReactterConsumer<ProductsController>(
                    listenStates: (_) => [product.stockState],
                    builder: (_, __, ___) {
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
              );
            },
          ),
        );
      },
    );
  }
}
