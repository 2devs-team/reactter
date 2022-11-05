import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CounterPage extends StatelessWidget {
  CounterPage({Key? key}) : super(key: key);

  final count = 0.signal;
  void increase() => count.value += 1;
  void decrease() => count.value -= 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReactterWatcher(
              builder: (context, child) {
                return Text(
                  "$count",
                  style: Theme.of(context).textTheme.headline3,
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: decrease,
                  child: const Text(" - Decrease"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: increase,
                  child: const Text("Increase +"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
