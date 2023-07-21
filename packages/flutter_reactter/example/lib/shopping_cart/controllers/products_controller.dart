import 'dart:math';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/product_state.dart';

Random _random = Random();

class ProductsController {
  final products = UseState(_generateProducts());

  static List<ProductState> _generateProducts() {
    return List.generate(
      26,
      (index) => ProductState(
        name: "Product ${String.fromCharCode(index + 65)}",
        price: (_random.nextInt(3000) + 100) + _random.nextDouble(),
        stock: _random.nextInt(20),
      ),
    );
  }
}
