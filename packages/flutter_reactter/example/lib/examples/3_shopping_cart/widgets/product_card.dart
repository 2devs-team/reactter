import 'package:examples/examples/3_shopping_cart/controllers/product_controller.dart';
import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:examples/examples/3_shopping_cart/utils/format_currency.dart';
import 'package:examples/examples/3_shopping_cart/widgets/product_buttons.dart';
import 'package:examples/examples/3_shopping_cart/widgets/product_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider(
      () => ProductController(product),
      id: "${product.id}",
      builder: (context, controller, child) {
        return Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.black45,
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: ProductCover(index: product.id),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: ProductButtons(
                          product: product,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatCurrency(product.price),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      _buildStock(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStock(BuildContext context) {
    if (product.stock == 0) {
      return Text(
        "Sold out",
        style: Theme.of(context).textTheme.labelSmall,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'In stock: ',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Text(
          "${product.stock}",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
