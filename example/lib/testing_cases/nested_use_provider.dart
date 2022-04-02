// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class CartItem {
  final String? id;
  final String? name;

  CartItem({this.id, this.name});
}

class AppContext extends ReactterContext {
  final userName = UseState<String>("Leo", alwaysUpdate: true);

  AppContext() {
    listenHooks([
      userName,
    ]);
  }

  changeUserName() {
    userName.value = "Otro user nuevo";
  }
}

class UseUser extends ReactterHook {
  late final items =
      UseState<List<CartItem>>([], alwaysUpdate: true, context: this);

  UseUser() {
    UseEffect(
      () {
        print("Items are changing");
      },
      [items],
      this,
    );
  }
}

class CartContext extends ReactterContext {
  final items = UseState<List<CartItem>>([], alwaysUpdate: true);
  final itemsLenght = UseState<int>(0, alwaysUpdate: true);
  final useUser = UseUser();

  CartContext() {
    listenHooks([
      items,
      itemsLenght,
    ]);

    UseEffect(
      () {
        print("Items are changing");
      },
      [items, useUser],
      this,
    );
  }

  addItemToCart() {
    useUser.items.value = [
      ...items.value,
      CartItem(
        id: getUnixTime(),
        name: "name${getUnixTime()}",
      ),
    ];

    itemsLenght.value = itemsLenght.value + 1;
    print(items.value);
  }

  String getUnixTime() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class NestedUseProvider extends StatelessWidget {
  const NestedUseProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UseProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          init: true,
        ),
        UseContext(
          () => CartContext(),
          init: true,
        ),
      ],
      builder: (contextA, _) {
        print('render contextA');

        return UseProvider(
          contexts: const [],
          builder: (contextB, _) {
            final cartContext = contextB.of<CartContext>();
            final appContext =
                contextB.of<AppContext>((inst) => [inst.userName]);

            return Scaffold(
              appBar: AppBar(
                title: const Text("Reactter example"),
              ),
              body: Container(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appContext.userName.value),
                      ElevatedButton(
                        onPressed: appContext.changeUserName,
                        child: const Text("Change user name"),
                      ),
                      const SizedBox(height: 20),
                      Text("Items: ${cartContext.itemsLenght.value}"),
                      const SizedBox(height: 20),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: cartContext.items.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            color: Colors.amber,
                            child: Center(
                              child: Text(
                                  'Entry ${cartContext.items.value[index].id}'),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: cartContext.addItemToCart,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }
}
