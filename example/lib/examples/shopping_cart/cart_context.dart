import 'package:reactter/reactter.dart';

import 'product_context.dart';

class CartContext extends ReactterContext {
  late final products = UseState<Map<ProductContext, int>>({}, this);
  late final productsLen = UseState(0, this);
  late final quantityProducts = UseState(0, this);
  late final total = UseState(0.0, this);

  CartContext() {
    UseEffect(_useEffectProducts, [products], this);
  }

  void addProduct(ProductContext product) {
    if (product.stockState.value < 1) {
      return;
    }

    product.stockState.value -= 1;

    products.update(() {
      products.value[product] = (products.value[product] ?? 0) + 1;
    });
  }

  void removeProduct(ProductContext product) {
    product.stockState.value += 1;

    products.update(() {
      products.value[product] = (products.value[product] ?? 0) - 1;

      if (products.value[product]! < 1) {
        products.value.remove(product);
      }
    });
  }

  void deleteProduct(ProductContext product) {
    if (products.value[product] == null) {
      return;
    }

    final quantity = products.value[product]!;
    product.stockState.value += quantity;

    products.update(() {
      products.value.remove(product);
    });
  }

  void checkout() => products.update(products.value.clear);

  void _useEffectProducts() {
    int quantityProducts = 0;
    double total = 0.0;

    for (final product in products.value.entries) {
      final price = product.key.price;
      final quantity = product.value;

      quantityProducts += quantity;
      total += price * quantity;
    }

    this.total.value = total;
    this.quantityProducts.value = quantityProducts;
    productsLen.value = products.value.length;
  }
}
