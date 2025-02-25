import 'package:examples/examples/3_shopping_cart/models/cart_item.dart';
import 'package:examples/examples/3_shopping_cart/repositories/cart_repository.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CartController {
  final _recentlyUpdatedCartItems = <CartItem>{};

  final uCartRepository = UseDependency.create(
    CartRepository.new,
    debugLabel: 'uCartRepository',
  );

  late final uAsyncCart = Rt.lazyState(() {
    assert(uCartRepository.instance != null);

    return UseAsyncState(
      uCartRepository.instance!.getCart,
      null,
      debugLabel: 'uAsyncCart',
    );
  }, this);

  late final uCartItems = Rt.lazyState(() {
    return UseCompute(
      () => uAsyncCart.value?.items.toList() ?? [],
      [uAsyncCart.uValue],
      debugLabel: 'uCartItems',
    );
  }, this);

  late final uTotal = Rt.lazyState(() {
    return UseCompute(
      () => uAsyncCart.value?.total ?? 0,
      [uAsyncCart.uValue],
      debugLabel: 'uTotal',
    );
  }, this);

  CartController() {
    _loadCartItems();
  }

  Future<void> incrementCartItem(CartItem cartItem) async {
    final newCartItem = cartItem.copyWith(quantity: cartItem.quantity + 1);
    await _updateCartItem(newCartItem);
  }

  Future<void> decrementCartItem(CartItem cartItem) async {
    final newCartItem = cartItem.copyWith(quantity: cartItem.quantity - 1);
    await _updateCartItem(newCartItem);
  }

  Future<void> removeCartItem(CartItem cartItem) async {
    await _updateCartItem(cartItem.copyWith(quantity: 0));
  }

  Future<void> checkout() async {
    await uCartRepository.instance?.checkout();
    await _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    uAsyncCart.cancel();
    await uAsyncCart.resolve();
  }

  bool _updateCartItemsState(CartItem cartItem) {
    final index = uCartItems.value.indexOf(cartItem);
    final product = cartItem.product;

    if (cartItem.quantity > product.stock) {
      return false;
    }

    uCartItems.value.remove(cartItem);

    if (cartItem.quantity > 0) {
      final indexToInsert = index < 0 ? uCartItems.value.length : index;
      uCartItems.value.insert(indexToInsert, cartItem);
    }

    uCartItems.notify();

    return true;
  }

  Future<CartItem?> _updateCartItem(CartItem cartItem) async {
    uAsyncCart.cancel();

    final isStateUpdated = _updateCartItemsState(cartItem);

    if (!isStateUpdated) return null;

    final isUpdating = _recentlyUpdatedCartItems.remove(cartItem);
    _recentlyUpdatedCartItems.add(cartItem);

    if (isUpdating) return cartItem;

    final cartItemUpdated = await uCartRepository.instance?.updateCartItem(
      cartItem,
    );

    final mostRecentCartItem = _recentlyUpdatedCartItems.lookup(cartItem);
    final isStillUpdating = mostRecentCartItem != null &&
        cartItem.quantity != mostRecentCartItem.quantity;

    _recentlyUpdatedCartItems.remove(mostRecentCartItem);

    if (isStillUpdating) {
      return await _updateCartItem(mostRecentCartItem);
    }

    if (_recentlyUpdatedCartItems.isEmpty) {
      await _loadCartItems();
    }

    return cartItemUpdated;
  }
}
