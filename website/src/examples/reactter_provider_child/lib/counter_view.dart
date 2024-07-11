import 'package:flutter/material.dart';
import 'counter.dart';
import 'counter_with_buttons.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: const Center(
        child: CounterWithButtons(),
      ),
      floatingActionButton: const CircleAvatar(
        child: Counter(),
      ),
    );
  }
}
