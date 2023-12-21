import 'package:flutter_reactter/flutter_reactter.dart';

import '../repositories/store_repository.dart';
import '../models/product.dart';

class ProductsController {
  final uStoreRepository = UseInstance.create(StoreRepository.new);
  final uProducts = UseState(<Product>[]);

  ProductsController() {
    loadProducts();
  }

  void loadProducts() {
    uProducts.update(() {
      uProducts.value = uStoreRepository.instance!.getProducts();
    });
  }
}
