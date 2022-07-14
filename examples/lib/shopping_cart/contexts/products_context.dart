import 'dart:math';
import 'package:reactter/reactter.dart';

import 'product_context.dart';

Random _random = Random();

class ProductsContext extends ReactterContext {
  late final products = UseState(_generateProducts(), this);

  List<ProductContext> _generateProducts() {
    return List.generate(
      26,
      (index) => ProductContext(
        name: "Product ${String.fromCharCode(index + 65)}",
        price: (_random.nextInt(3000) + 100) + _random.nextDouble(),
        initialStock: _random.nextInt(20),
      ),
    );
  }
}
