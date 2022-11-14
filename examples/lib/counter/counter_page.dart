import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

final count = 0.signal;
void increase() => count.value++;
void decrease() => count.value--;

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

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
              children: const [
                ElevatedButton(
                  onPressed: decrease,
                  child: Text(" - Decrease"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: increase,
                  child: Text("Increase +"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
