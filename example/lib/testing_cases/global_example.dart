// ignore_for_file: avoid_print

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
  static final reverse = UseState(false);
  static final count = UseCount(0);
  static final maxCount = UseCount(10);

  static final Global _inst = Global._init();
  factory Global() => _inst;

  Global._init() {
    UseEffect(
      () {
        Future.delayed(const Duration(seconds: 1), doCount);
      },
      [count],
      UseEffect.dispatchEffect,
    );
  }

  static void doCount() {
    if (reverse.value && count.value <= 0) {
      reverse.value = false;
      maxCount.increment();
    }

    if (!reverse.value && count.value >= maxCount.value) {
      reverse.value = true;
    }

    reverse.value ? count.decrement() : count.increment();
  }
}

class AppContext extends ReactterContext {
  final count = Global.count;
  final maxCount = Global.maxCount;
  final reverse = Global.reverse;

  AppContext() {
    // It's need to instance it for can execute Global._init
    Global();

    onWillUpdate(() => print("onWillUpdate"));
    onDidUpdate(() => print("onDidUpdate"));

    listenHooks([count, maxCount, reverse]);
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
        return Scaffold(
          appBar: AppBar(
            title: const Text("Global example"),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactterBuilder<AppContext>(
                  listenHooks: (_) => [_.reverse, _.maxCount],
                  builder: (_, context, __) {
                    print('RENDER FLAG');
                    return Text(
                      Global.reverse.value
                          ? 'Count decrement ${Global.maxCount.value} to 0'
                          : 'Count increment 0 to ${Global.maxCount.value}',
                    );
                  },
                ),
                ReactterBuilder<AppContext>(
                  listenHooks: (_) => [_.count],
                  builder: (appContext, context, __) {
                    print('RENDER COUNT');
                    return Text(
                      "${Global.count.value} is ${appContext.isOdd ? "odd" : "even"}",
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
