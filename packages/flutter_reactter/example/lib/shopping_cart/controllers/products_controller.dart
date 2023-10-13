import 'package:flutter_reactter/flutter_reactter.dart';

import '../repositories/store_repository.dart';
import '../models/product.dart';

class ProductsController {
  final useStoreRepository = UseInstance.create(StoreRepository.new);
  final products = UseState(<Product>[]);

  ProductsController() {
    loadProducts();
  }

  void loadProducts() {
    products.update(() {
      products.value = useStoreRepository.instance!.getProducts();
    });
  }
}
