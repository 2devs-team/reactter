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
          children: [
            const Counter(),
            SizedBox(height: 8),
            const CounterDivisible(byNum: 2),
            SizedBox(height: 8),
            const CounterDivisible(byNum: 3),
            SizedBox(height: 8),
            const CounterDivisible(byNum: 5),
          ],
        ),
      ),
    );
  }
}
