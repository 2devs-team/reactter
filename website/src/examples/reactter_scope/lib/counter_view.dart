import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

final count = Signal(0);

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => count.value--,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
            ReactterConsumer(
              listenStates: (_) => [count],
              builder: (_, __, ___) {
                return Text('Count: ${count}');
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => count.value++,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
