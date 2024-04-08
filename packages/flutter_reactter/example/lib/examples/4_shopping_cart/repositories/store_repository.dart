import 'dart:math';

import 'package:examples/examples/4_shopping_cart/models/cart.dart';
import 'package:examples/examples/4_shopping_cart/models/cart_item.dart';
import 'package:flutter/material.dart';

import 'package:examples/examples/4_shopping_cart/models/product.dart';
import 'package:examples/examples/4_shopping_cart/utils/lorem_gen.dart';

class StoreRepository {
  static final _random = Random();
  final _products = _generateProducts();
  final _cartItems = <Product, CartItem>{};
  int _cartItemsCount = 0;
  double _total = 0.0;

  List<Product> getProducts() => _products;

  Cart addProductToCart(Product product, [int quantity = 1]) {
    final item = _cartItems[product] ?? CartItem(product, 0);

    _cartItems[product] = item.copyWith(quantity: item.quantity + quantity);
    _cartItemsCount += quantity;
    _total += product.price * quantity;

    return Cart(
      items: _cartItems.values.toList(),
      itemsCount: _cartItemsCount,
      total: _total,
    );
  }

  Cart removeProductFromCart(Product product, [int quantity = 1]) {
    final item = _cartItems[product] ?? CartItem(product, 0);

    if (item.quantity <= quantity) {
      _cartItems.remove(product);
    } else {
      _cartItems[product] = item.copyWith(quantity: item.quantity - quantity);
    }

    _cartItemsCount -= quantity;
    _total -= product.price * quantity;

    return Cart(
      items: _cartItems.values.toList(),
      itemsCount: _cartItemsCount,
      total: _total,
    );
  }

  Cart deleteProductFromCart(Product product) {
    final item = _cartItems[product] ?? CartItem(product, 0);

    _cartItems.remove(product);
    _cartItemsCount -= item.quantity;
    _total -= item.product.price * item.quantity;

    return Cart(
      items: _cartItems.values.toList(),
      itemsCount: _cartItemsCount,
      total: _total,
    );
  }

  void checkout(List<CartItem> items) {
    final productsChanged = _products.map((product) {
      final item = items.firstWhere(
        (element) => element.product == product,
        orElse: () => CartItem(product, 0),
      );
      final quantity = item.quantity;

      return product.copyWith(stock: product.stock - quantity);
    }).toList();

    _products.clear();
    _products.addAll(productsChanged);
    _cartItems.clear();
    _cartItemsCount = 0;
    _total = 0.0;
  }

  static List<Product> _generateProducts() {
    final colors = [...Colors.primaries, ...Colors.accents];

    return List.generate(
      26,
      (index) {
        final letter = String.fromCharCode(index + 65);
        final iColor = _random.nextInt(colors.length);
        final color = colors[iColor][100]!.value.toRadixString(16).substring(2);
        final color2 =
            colors[iColor][700]!.value.toRadixString(16).substring(2);

        return Product(
          name: generateLoremText(_random.nextInt(8) + 3),
          image: 'https://placehold.co/200/$color/$color2/png?text=$letter',
          price: (_random.nextInt(3000) + 100) + _random.nextDouble(),
          stock: _random.nextInt(20),
        );
      },
    );
  }
}
