import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/product.dart';
import '../repositories/store_repository.dart';

class CartController {
  final useStoreRepository = UseInstance.create(StoreRepository.new);
  final items = UseState(<Product, int>{});
  final itemsCount = UseState(0);
  final total = UseState(0.0);

  int getQuantity(Product product) => items.value[product] ?? 0;

  void addItem(Product product) {
    final quantity = (items.value[product] ?? 0) + 1;

    if (quantity > product.stock) return;

    items.update(() {
      items.value[product] = quantity;
    });

    itemsCount.value += 1;
    total.value += product.price;
  }

  void removeItem(Product product) {
    final quantity = (items.value[product] ?? 0) - 1;

    if (quantity < 0) return;

    items.update(() {
      if (quantity == 0) {
        items.value.remove(product);
        return;
      }

      items.value[product] = quantity;
    });

    itemsCount.value -= 1;
    total.value -= product.price;
  }

  void deleteItem(Product product) {
    if (items.value[product] == null) {
      return;
    }

    final quantity = items.value[product]!;

    items.update(() {
      items.value.remove(product);
    });

    itemsCount.value -= quantity;
    total.value -= product.price * quantity;
  }

  void checkout() {
    useStoreRepository.instance!.checkout(items.value);
    items.update(items.value.clear);
    itemsCount.value = 0;
    total.value = 0;
  }
}
