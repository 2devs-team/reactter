import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:examples/examples/3_shopping_cart/repositories/product_repository.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class ProductsController {
  final uProductRepository = UseDependency.create(ProductRepository.new);

  late final uAsyncProducts = Rt.lazyState(
    () {
      assert(uProductRepository.instance != null);

      return UseAsyncState<List<Product>>(
        uProductRepository.instance!.getAllProducts,
        [],
        debugLabel: 'uAsyncProducts',
      );
    },
    this,
  );

  ProductsController() {
    uAsyncProducts.resolve();
  }
}
