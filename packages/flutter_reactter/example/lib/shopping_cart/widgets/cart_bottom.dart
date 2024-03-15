// ignore_for_file: avoid_renaming_method_parameters

import 'package:flutter/material.dart';

import '../utils/format_currency.dart';

class CartBottom extends StatelessWidget {
  final int productsCount;
  final int itemsCount;
  final double total;
  final void Function()? onCheckout;

  const CartBottom({
    Key? key,
    this.productsCount = 0,
    this.itemsCount = 0,
    this.total = 0,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      elevation: 16,
      enableDrag: false,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          "$itemsCount "
                          "${itemsCount == 1 ? 'item' : 'items'} ",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          "of $productsCount "
                          "${productsCount == 1 ? 'product' : 'products'}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Total: ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        formatCurrency(total),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCheckout,
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
  }
}
