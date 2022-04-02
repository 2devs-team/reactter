import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

void main() {
  test(
    'GIVEN product with 0 quantity WHEN incrementQuantity is called whit 5 THEN quantity of product is 5',
    () {
      // ARRANGE
      final product = Product("Apple", 5);

      // ACT
      product.incrementQuantity(5);

      // ASSERT
      expect(product.quantity.value, 5);
    },
  );

  test(
    'GIVEN cart with 0 products in list WHEN add product is called THEN cart total sum all product. First result: 5. Second result: 46',
    () {
      // ARRANGE
      final cart = Cart();
      final fistProduct = Product("Apple", 5);
      final secondProduct = Product("Orange", 7);

      // ACT
      fistProduct.incrementQuantity(5);
      cart.addProduct(fistProduct);

      // ASSERT
      expect(cart.total.value, 25); // 5 * 5

      // ACT
      secondProduct.incrementQuantity(3);
      cart.addProduct(secondProduct);

      // ASSERT
      expect(cart.total.value, 46); // (5 * 5 ) + (7 * 3)
    },
  );
}

mixin UseQuantity {
  final quantity = UseState<int>(0);

  void incrementQuantity(int _quantity) =>
      quantity.value = quantity.value + _quantity;

  void decrementQuantity(int _quantity) =>
      quantity.value = quantity.value - _quantity;
}

class Product with UseQuantity {
  String name;
  double price;

  Product(this.name, this.price);
}

class Cart {
  final products = UseState<List<Product>>([], alwaysUpdate: true);

  final total = UseState<double>(0);

  Cart() {
    UseEffect(
      () {
        setTotal();
      },
      [products],
    );
  }

  void setTotal() {
    double newTotal = 0;

    for (var item in products.value) {
      newTotal += item.quantity.value * item.price;
    }

    total.value = newTotal;
  }

  void addProduct(Product product) {
    final newProducts = [...products.value, product];

    products.value = newProducts;
  }
}
