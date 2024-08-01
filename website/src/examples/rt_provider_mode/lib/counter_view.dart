import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter.dart';
import 'counter_controller.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showCounter = Signal(false);

    _listenLifecycle();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: RtSignalWatcher(
          child: ElevatedButton(
            onPressed: () => showCounter.value = !showCounter.value,
            child: showCounter.value
                ? Text("Hide Counters")
                : Text("Show Counters"),
          ),
          builder: (context, child) {
            return Column(
              children: [
                child!,
                if (showCounter.value) ...[
                  const SizedBox(height: 8),
                  // Will register and create the `CounterController` dependency each time.
                  const Counter(mode: DependencyMode.builder),
                  const SizedBox(height: 8),
                  // Will register the `CounterController` dependency only once.
                  const Counter(mode: DependencyMode.factory),
                  const SizedBox(height: 8),
                  // Will register and create the `CounterController` dependency only once,
                  // this keeps the counter value between rebuilds
                  const Counter(mode: DependencyMode.singleton),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _listenLifecycle() {
    for (final mode in DependencyMode.values) {
      Rt.on(
        RtDependency<CounterController>(
          mode.toString(),
        ),
        Lifecycle.registered,
        (_, __) {
          print("CounterController registered with ${mode.toString()}.");
        },
      );

      Rt.on(
        RtDependency<CounterController>(
          mode.toString(),
        ),
        Lifecycle.created,
        (_, __) {
          print("CounterController created with ${mode.toString()}.");
        },
      );

      Rt.on(
        RtDependency<CounterController>(
          mode.toString(),
        ),
        Lifecycle.deleted,
        (_, __) {
          print("CounterController deleted with ${mode.toString()}.");
        },
      );

      Rt.on(
        RtDependency<CounterController>(
          mode.toString(),
        ),
        Lifecycle.unregistered,
        (_, __) {
          print("CounterController unregistered with ${mode.toString()}.");
        },
      );
    }
  }
}
