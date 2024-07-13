import 'package:flutter/material.dart';
import 'counter.dart';
import 'counter_divisible.dart';

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
          children: const [
            Counter(id: "Counter1"),
            SizedBox(height: 8),
            CounterDivisible(byNum: 2, id: "Counter1"),
            SizedBox(height: 8),
            CounterDivisible(byNum: 5, id: "Counter1"),
            SizedBox(height: 16),
            Counter(id: "Counter2"),
            SizedBox(height: 8),
            CounterDivisible(byNum: 3, id: "Counter2"),
          ],
        ),
      ),
    );
  }
}
