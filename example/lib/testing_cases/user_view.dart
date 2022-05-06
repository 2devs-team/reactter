// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:example/data/models/cart.dart';
import 'package:example/data/models/mocks.dart';
import 'package:example/testing_cases/use_effect_example.dart';
import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

mixin UseCart on ReactterHookManager {
  late final cart = UseState<Cart?>(null, alwaysUpdate: true, context: this);

  removeItemFromCart(int productId) {
    final newProducts = cart.value?.products
        ?.where((element) => element.id != productId)
        .toList();

    final newCart = cart.value?.copyWith(products: newProducts);

    cart.value = newCart;
  }
}

class UserContext extends ReactterContext with UseCart {
  final user = Global.currentUser;

  UserContext(AppContext appcontext) {
    UseEffect(() {
      log('"UseEffect UserApp": INITIALIZE');

      cart.value = Mocks.getUserCart(user.value?.id ?? 0);

      return () {
        log('"UseEffect UserApp": DISPOSE');
      };
    }, [user], this);
  }

  updateCart() {
    cart.value = Mocks.getUserCart(user.value?.id ?? 0);
  }
}

class UserView extends StatelessWidget {
  final AppContext appcontext;

  const UserView(this.appcontext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UseProvider(
      contexts: [
        UseContext(
          () => UserContext(appcontext),
          init: true,
        ),
      ],
      builder: (context, _) {
        print("REBUILD ROOT");
        final userStatic = context.ofStatic<UserContext>();

        return Scaffold(
          appBar: AppBar(
            title: Text("User: " + userStatic.user.value!.firstName!),
          ),
          body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Builder(builder: (context) {
              final userDynamic = context.of<UserContext>();

              final cart = userDynamic.cart.value;

              print("- REBUILD CART");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("items in cart: ${cart?.products?.length ?? 0}"),
                  const SizedBox(height: 20),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: cart?.products?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final product = cart?.products?[index];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Center(
                              child: Text('${product?.title} '),
                            ),
                          ),
                          ElevatedButton(
                            key: Key('remove_${index + 1}'), //Testing purposes
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              userDynamic.removeItemFromCart(product?.id ?? 0);
                            },
                            child: const Text("Remove"),
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
