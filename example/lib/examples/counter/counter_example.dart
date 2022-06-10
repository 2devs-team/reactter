import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'counter_context.dart';

class CounterExample extends StatelessWidget {
  const CounterExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => CounterContext()),
      ],
      builder: (context, _) {
        // final counterCtx = context.read<CounterContext>();
        final counterCtx = context.ofStatic<CounterContext>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Counter"),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactterBuilder<CounterContext>(
                  builder: (counterCtx, context, child) {
                    // context.watch<CounterContext>();
                    context.of<CounterContext>();

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
                      child: const Text("Increment +*"),
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
