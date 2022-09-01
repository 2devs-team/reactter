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

  void incrementStock([int quantity = 1]) => stockState.value += quantity;

  void decrementStock([int quantity = 1]) {
    if (stockState.value < 1) return;

    stockState.value -= quantity;
  }
}

String formatCurrency(double value) {
  final valueFormatted =
      value.toStringAsFixed(2).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');

  return "\$$valueFormatted";
}
