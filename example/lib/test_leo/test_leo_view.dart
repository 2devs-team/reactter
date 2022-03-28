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

class UseUser extends ReactterHookGestor {
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

class TestLeoView extends StatelessWidget {
  const TestLeoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return UseProvider(
        contexts: [
          //// Se crea la instancia de manera asyncrona
          // UseContext.async(() async => AppContext()),
          UseContext(
            () => AppContext(),
            // eliminar init, es igual a lazy=false
            init: true,
            //// Se crea la instancia en el primer context que lo requiera
            //// y se elimina la instancia cuando no hay contexts que lo requiera
            // lazy: true,
            //// Todo context con id es una instancia nueva
            // id: 'key',
          ),
          UseContext(
            () => CartContext(),
            init: true,
          ),
        ],
        builder: (contextA, _) {
          print('render contextA');
          // final _appContext = context.static<AppContext>();
          final cartContext = contextA.static<CartContext>();
          // print(_appContext.userName.value);

          return UseProvider(
              contexts: [],
              builder: (contextB, _) {
                final cartContext = contextB.$<CartContext>();
                final appContext =
                    contextB.$<AppContext>((inst) => [inst.userName]);

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
              });
        });
  }
}
