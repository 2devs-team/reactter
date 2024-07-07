import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Register a dependency as builder mode.
  Reactter.lazyBuilder<Counter>(() => Counter());

  // Get the dependency
  final counter = Reactter.get<Counter>();
  print("counter: ${counter?.hashCode}");

  // Listen to the state changes
  Reactter.on(
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
  Reactter.delete<Counter>();

  // Error: "Can't update when it's been disposed", because the dependency instance was deleted
  // counter.increment();

  // Can't get the dependency instance, because the dependency register was deleted
  final counter2 = Reactter.get<Counter>();
  print("counter2: ${counter2?.hashCode}"); // counter2: null

  // Register a dependency using `id` parameter as builder mode
  Reactter.lazyBuilder(() => Counter(), id: 'CounterById');

  // Get the dependency using `id` parameter
  final counterById = Reactter.get<Counter>('CounterById');
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency using `id` parameter
  Reactter.delete<Counter>('CounterById');

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
