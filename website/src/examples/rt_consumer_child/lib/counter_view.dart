import 'package:flutter/material.dart';
import 'counter.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Counter(id: 'counter1'),
            const SizedBox(height: 8),
            const Counter(id: 'counter2'),
          ],
        ),
      ),
    );
  }
}
