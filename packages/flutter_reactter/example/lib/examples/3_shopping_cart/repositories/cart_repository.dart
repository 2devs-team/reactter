import 'package:examples/examples/3_shopping_cart/data/data_source.dart';
import 'package:examples/examples/3_shopping_cart/models/cart.dart';
import 'package:examples/examples/3_shopping_cart/models/cart_item.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

abstract class ICartRepository {
  Future<Cart> getCart();
  Future<CartItem?> updateCartItem(CartItem cartItem);
  Future<void> checkout();
}

class CartRepository implements ICartRepository {
  final _uDataSource = UseDependency.create(DataSource.new);

  DataSource get _dataSource {
    return _uDataSource.instance ?? (throw Exception('DataSource not found'));
  }

  @override
  Future<Cart> getCart() async => _dataSource.fetchCart();

  @override
  Future<CartItem?> updateCartItem(CartItem cartItem) async {
    if (cartItem.quantity <= 0) {
      await _dataSource.deleteCartItem(cartItem);

      return null;
    }

    return await _dataSource.putCartItem(cartItem);
  }

  @override
  Future<void> checkout() async {
    await _dataSource.checkout();
  }
}
