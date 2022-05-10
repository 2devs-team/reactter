import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

class UseCount extends ReactterHook {
  final int _initial;

  late final _count = UseState(_initial, this);

  int get value => _count.value;

  UseCount(int initial, [ReactterContext? context])
      : _initial = initial,
        super(context);

  int increment() => _count.value += 1;
  int decrement() => _count.value -= 1;
}

class Global {
  static final flag = UseState(false);
  static final count = UseCount(0);

  static final Global _inst = Global._init();
  factory Global() => _inst;

  Global._init() {
    UseEffect(
      () async {
        await Future.delayed(const Duration(seconds: 1));
        doCount();
      },
      [count],
      UseEffect.dispatchEffect,
    );
  }

  static void doCount() {
    if (count.value <= 0) {
      flag.value = true;
    }

    if (count.value >= 10) {
      flag.value = false;
    }

    flag.value ? count.increment() : count.decrement();
  }
}

class AppContext extends ReactterContext {
  AppContext() {
    Global(); // Alway invoke Global's factory
  }

  bool get isOdd => Global.count.value % 2 != 0;
}

class GlobalExample extends StatelessWidget {
  const GlobalExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => AppContext()),
      ],
      builder: (context, child) {
        final appContext = context.of<AppContext>((_) => [Global.count]);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Global example"),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Global.flag.value ? 'Count increment' : 'Count decrement',
                ),
                Text(
                  "${Global.count.value} is ${appContext.isOdd ? "odd" : "even"}",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
