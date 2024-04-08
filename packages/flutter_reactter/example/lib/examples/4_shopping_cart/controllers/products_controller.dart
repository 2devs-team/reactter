import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/4_shopping_cart/repositories/store_repository.dart';

class ProductsController {
  final uStoreRepository = UseInstance.create(StoreRepository.new);
  late final uProducts = Reactter.lazyState(
    () => UseState(uStoreRepository.instance?.getProducts() ?? []),
    this,
  );
}
