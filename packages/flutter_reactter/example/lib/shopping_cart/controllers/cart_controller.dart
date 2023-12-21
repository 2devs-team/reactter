import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/product.dart';
import '../repositories/store_repository.dart';

class CartController {
  final uStoreRepository = UseInstance.create(StoreRepository.new);
  final uItems = UseState(<Product, int>{});
  final uItemsCount = UseState(0);
  final uTotal = UseState(0.0);

  void addItem(Product product) {
    final quantity = (uItems.value[product] ?? 0) + 1;

    if (quantity > product.stock) return;

    uItems.update(() {
      uItems.value[product] = quantity;
    });

    uItemsCount.value += 1;
    uTotal.value += product.price;
  }

  void removeItem(Product product) {
    final quantity = (uItems.value[product] ?? 0) - 1;

    if (quantity < 0) return;

    uItems.update(() {
      if (quantity == 0) {
        uItems.value.remove(product);
        return;
      }

      uItems.value[product] = quantity;
    });

    uItemsCount.value -= 1;
    uTotal.value -= product.price;
  }

  void deleteItem(Product product) {
    if (uItems.value[product] == null) {
      return;
    }

    final quantity = uItems.value[product]!;

    uItems.update(() {
      uItems.value.remove(product);
    });

    uItemsCount.value -= quantity;
    uTotal.value -= product.price * quantity;
  }

  void checkout() {
    uStoreRepository.instance?.checkout(uItems.value);
    uItems.update(uItems.value.clear);
    uItemsCount.value = 0;
    uTotal.value = 0;
  }
}
