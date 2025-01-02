import 'dart:math';

import 'package:examples/examples/3_shopping_cart/models/cart.dart';
import 'package:examples/examples/3_shopping_cart/models/cart_item.dart';
import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:examples/examples/3_shopping_cart/utils/lorem_gen.dart';

const delay = Duration(milliseconds: 500);

abstract class IDataSource {
  Future<List<Product>> fetchAllProducts();
  Future<Cart> fetchCart();
  Future<CartItem?> fetchCartItemByProduct(Product product);
  Future<CartItem?> putCartItem(CartItem cartItem);
  Future<void> deleteCartItem(CartItem cartItem);
  Future<void> checkout();
}

class DataSource implements IDataSource {
  static final _random = Random();

  static final dataSource = DataSource._();

  Cart _cart = Cart();
  final _products = _generateProducts();

  DataSource._();

  factory DataSource() {
    return dataSource;
  }

  @override
  Future<List<Product>> fetchAllProducts() async {
    await Future.delayed(delay);
    return _products;
  }

  @override
  Future<Cart> fetchCart() async {
    await Future.delayed(delay);
    return _cart;
  }

  @override
  Future<CartItem?> fetchCartItemByProduct(Product product) async {
    await Future.delayed(delay);
    return _cart.items.lookup(CartItem(product, 0));
  }

  @override
  Future<CartItem?> putCartItem(CartItem cartItem) async {
    await Future.delayed(delay);

    final newItems = {
      ..._cart.items.map((item) => item == cartItem ? cartItem : item),
      cartItem,
    };
    final cartItemPrev = _cart.items.lookup(cartItem);
    final cartItemPrevTotal = cartItemPrev != null
        ? cartItemPrev.product.price * cartItemPrev.quantity
        : 0;
    final cartItemTotal = cartItem.product.price * cartItem.quantity;

    _cart = _cart.copyWith(
      items: newItems,
      total: _cart.total - cartItemPrevTotal + cartItemTotal,
    );

    return cartItem;
  }

  @override
  Future<void> deleteCartItem(CartItem cartItem) async {
    await Future.delayed(delay);

    final cartItemPrev = _cart.items.lookup(cartItem);
    final cartItemPrevTotal = cartItemPrev != null
        ? cartItemPrev.product.price * cartItemPrev.quantity
        : 0;

    _cart.items.remove(cartItem);
    _cart = _cart.copyWith(
      items: _cart.items,
      total: _cart.total - cartItemPrevTotal,
    );
  }

  @override
  Future<void> checkout() async {
    await Future.delayed(delay);

    for (final item in _cart.items) {
      final product = item.product;
      final newStock = product.stock - item.quantity;
      final index = _products.indexOf(product);

      _products.remove(product);
      _products.insert(index, product.copyWith(stock: newStock));
    }

    _cart = Cart();
  }

  static List<Product> _generateProducts() {
    return List.generate(
      26,
      (index) {
        return Product(
          id: index,
          name: generateLoremText(_random.nextInt(8) + 3),
          price: (_random.nextInt(3000) + 100) + _random.nextDouble(),
          stock: _random.nextInt(20),
        );
      },
    );
  }
}
