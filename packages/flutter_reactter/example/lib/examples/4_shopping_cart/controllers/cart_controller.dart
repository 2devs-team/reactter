import 'package:examples/examples/4_shopping_cart/models/product.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_shopping_cart/models/cart.dart';
import 'package:examples/examples/4_shopping_cart/models/cart_item.dart';
import 'package:examples/examples/4_shopping_cart/repositories/store_repository.dart';

class CartController {
  final uStoreRepository = UseInstance.create(StoreRepository.new);
  final uCartItems = UseState<List<CartItem>>([]);
  final uCartItemsCount = UseState<int>(0);
  final uTotal = UseState<double>(0.0);

  int getProductQuantity(Product product) {
    return uCartItems.value
        .firstWhere(
          (item) => item.product == product,
          orElse: () => CartItem(product, 0),
        )
        .quantity;
  }

  void addProduct(Product product) {
    final cart = uStoreRepository.instance?.addProductToCart(product);
    if (cart != null) _setState(cart);
  }

  void removeProduct(Product product) {
    final cart = uStoreRepository.instance?.removeProductFromCart(product);
    if (cart != null) _setState(cart);
  }

  void deleteProduct(Product product) {
    final cart = uStoreRepository.instance?.deleteProductFromCart(product);
    if (cart != null) _setState(cart);
  }

  void checkout() {
    uStoreRepository.instance?.checkout(uCartItems.value);
    _setState(Cart());
  }

  void _setState(Cart cart) {
    uCartItems.value = cart.items;
    uCartItemsCount.value = cart.itemsCount;
    uTotal.value = cart.total;
  }
}
