import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create a dependency as builder mode.
  final counter = Rt.builder<Counter>(() => Counter());
  print("counter: ${counter?.hashCode}");

  // Listen to the state changes
  Rt.on(
    counter!.count,
    Lifecycle.didUpdate,
    (_, __) {
      print("Count: ${counter.count.value}");
    },
  );

  // Update the state
  counter.increment();
  counter.decrement();

  // Delete the dependency
  Rt.delete<Counter>();

  // Error: "Can't update when it's been disposed", because the dependency instance was deleted
  // counter.increment();

  // Can't get the dependency instance, because the dependency register was deleted
  final counter2 = Rt.get<Counter>();
  print("counter2: ${counter2?.hashCode}"); // counter2: null

  // Create a dependency using `id` parameter as builder mode
  final counterById = Rt.builder<Counter>(
    () => Counter(),
    id: 'CounterById',
  );
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency using `id` parameter
  Rt.delete<Counter>('CounterById');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: Text('See the output in the terminal'),
        ),
      ),
    );
  }
}
