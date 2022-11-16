import 'package:flutter_reactter/flutter_reactter.dart';

import 'product.dart';

class ProductState extends Product {
  int get initialStock => super.stock;

  late final stockState = UseState(0);
  @override
  get stock => stockState.value;

  ProductState({
    required super.name,
    required super.price,
    required super.stock,
  }) {
    stockState.value = initialStock;
  }

  bool increaseStock([int quantity = 1]) {
    if (stockState.value > initialStock) return false;

    stockState.value += quantity;

    return true;
  }

  bool decreaseStock([int quantity = 1]) {
    if (stockState.value < 1) return false;

    stockState.value -= quantity;

    return true;
  }
}

String formatCurrency(double value) {
  final valueFormatted =
      value.toStringAsFixed(2).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');

  return "\$$valueFormatted";
}
