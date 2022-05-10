// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class CartItem {
  final String? id;
  final String? name;

  CartItem({this.id, this.name});
}

class AppContext extends ReactterContext {
  final userName = UseState<String>("Leo");
  late final flag = UseState(false, this);

  AppContext() {
    print('1. Initialized');

    UseEffect(() {
      Future.delayed(const Duration(seconds: 1), () {
        flag.value = !flag.value;
      });
    }, [flag], this);

    onWillMount(() => print('2. Before mount'));
    onDidMount(() => print('3. Mounted'));
    onWillUpdate(() => print('4. Before update'));
    onDidUpdate(() => print('5. Updated'));
    onWillUnmount(() => print('6. Before unmounted'));
    listenHooks([
      userName,
    ]);
  }

  changeUserName() {
    userName.value = "Otro user nuevo";
  }
}

class UseUser extends ReactterHook {
  late final items = UseState<List<CartItem>>([], this);

  UseUser([ReactterContext? context]) : super(context) {
    UseEffect(() {
      print("Items are changing from User");
    }, [items]);
  }
}

class CartContext extends ReactterContext {
  late final items = UseState<List<CartItem>>([], this);
  late final itemsLenght = UseState<int>(0, this);
  late final user = UseUser(this);

  CartContext() {
    UseEffect(() {
      print("Items are changing from cart");
    }, [items], this);
  }

  addItemToCart() {
    user.items.value = items.value = [
      ...items.value,
      CartItem(
        id: getUnixTime(),
        name: "name${getUnixTime()}",
      ),
    ];

    itemsLenght.value = itemsLenght.value + 1;
  }

  String getUnixTime() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class NestedReactterProvider extends StatelessWidget {
  const NestedReactterProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(
          () => AppContext(),
          onInit: (inst) => print('on init'),
        ),
        UseContext(
          () => CartContext(),
          init: true,
        ),
      ],
      builder: (contextA, _) {
        print('render contextA');

        return ReactterProvider(
          contexts: const [],
          builder: (contextB, _) {
            print('render contextB');
            final appContext = contextB.of<AppContext>((ctx) => [ctx.userName]);

            final cartContext = contextB.of<CartContext?>();

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
                      ReactterBuilder<AppContext>(
                        listenHooks: (ctx) => [ctx.flag],
                        builder: (ctx, _, __) {
                          print("CHANGE FLAG");
                          return Text("flag: ${ctx.flag.value}");
                        },
                      ),
                      ElevatedButton(
                        onPressed: appContext.changeUserName,
                        child: const Text("Change user name"),
                      ),
                      const SizedBox(height: 20),
                      Text("Items: ${cartContext?.itemsLenght.value}"),
                      const SizedBox(height: 20),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: cartContext?.items.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            color: Colors.amber,
                            child: Center(
                              child: Text(
                                  'Entry ${cartContext?.items.value[index].id}'),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: cartContext?.addItemToCart,
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
