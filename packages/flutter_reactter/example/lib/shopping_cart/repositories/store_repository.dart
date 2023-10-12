import 'dart:math';

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/lorem_gen.dart';

class StoreRepository {
  static final _random = Random();
  final _products = _generateProducts();

  List<Product> getProducts() => _products;

  void checkout(Map<Product, int> items) {
    final productsChanged = _products.map((product) {
      final quantity = items[product] ?? 0;

      return product.copyWith(stock: product.stock - quantity);
    }).toList();

    _products.clear();
    _products.addAll(productsChanged);
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
