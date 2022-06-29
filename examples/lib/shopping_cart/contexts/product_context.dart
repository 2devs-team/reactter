import 'package:reactter/reactter.dart';

class ProductContext extends ReactterContext {
  final String name;
  final double price;
  final int initialStock;

  late final stockState = UseState(initialStock, this);

  ProductContext({
    required this.name,
    required this.price,
    required this.initialStock,
  });
}

String formatCurrency(double value) {
  final valueFormatted =
      value.toStringAsFixed(2).replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');

  return "\$$valueFormatted";
}
