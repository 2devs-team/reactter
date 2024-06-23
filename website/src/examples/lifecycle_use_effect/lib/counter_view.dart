import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final showCounter = Signal(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter - Lifecycle using UseEffect"),
      ),
      body: ReactterWatcher(
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
