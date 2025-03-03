import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter.dart';
import 'counter_controller.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Rt.on(
      RtDependencyRef<CounterController>(),
      Lifecycle.unregistered,
      (_, __) => print('CounterController unregistered'),
    );

    Rt.on(
      RtDependencyRef<CounterController>(),
      Lifecycle.registered,
      (_, __) => print('CounterController registered'),
    );

    Rt.on(
      RtDependencyRef<CounterController>(),
      Lifecycle.created,
      (_, __) => print('CounterController created'),
    );

    Rt.on(
      RtDependencyRef<CounterController>(),
      Lifecycle.deleted,
      (_, __) => print('CounterController deleted'),
    );

    final showCounter = Signal(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter - Lifecycle using EventHandler"),
      ),
      body: RtSignalWatcher(
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => showCounter(!showCounter.value),
                  child: showCounter.value
                      ? const Text('Hide counter')
                      : const Text('Show Counter'),
                ),
                const SizedBox(height: 8),
                if (showCounter.value) const Counter(),
              ],
            ),
          );
        },
      ),
    );
  }
}
