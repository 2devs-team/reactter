import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CounterContext extends ReactterContext {
  late final count = UseState(0, this);

  void increment() => count.value += 1;
  void decrement() => count.value -= 1;
}

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => CounterContext(),
      builder: (context, _) {
        final counterCtx = context.use<CounterContext>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Counter"),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactterScope(
                  builder: (context, buttons) {
                    context.watch<CounterContext>();

                    return Text(
                      "${counterCtx.count.value}",
                      style: Theme.of(context).textTheme.headline3,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: counterCtx.decrement,
                      child: const Text(" - Decrement"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: counterCtx.increment,
                      child: const Text("Increment +"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
