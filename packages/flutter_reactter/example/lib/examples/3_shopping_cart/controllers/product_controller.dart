import 'package:examples/examples/3_shopping_cart/controllers/cart_controller.dart';
import 'package:examples/examples/3_shopping_cart/models/cart_item.dart';
import 'package:examples/examples/3_shopping_cart/models/product.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class ProductController {
  final Product product;

  final uCartController = UseDependency.create(CartController.new);

  late final uQuantity = Rt.lazyState(() {
    assert(uCartController.instance != null);

    return UseCompute(
      () {
        final cartItem = uCartController.instance!.uCartItems.value.firstWhere(
          (item) => item.product == product,
          orElse: () => CartItem(product, 0),
        );

        return cartItem.quantity;
      },
      [uCartController.instance!.uCartItems],
    );
  }, this);

  ProductController(this.product);

  Future<void> addToCart() async {
    await uCartController.instance?.incrementCartItem(
      CartItem(product, uQuantity.value),
    );
  }

  Future<void> removeFromCart() async {
    await uCartController.instance?.decrementCartItem(
      CartItem(product, uQuantity.value),
    );
  }
}
