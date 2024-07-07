import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create a dependency
  Reactter.create<Counter>(() => Counter());

  // Find the dependency
  final counter = Reactter.find<Counter>();
  print("counter: ${counter?.hashCode}");

  // Delete the dependency
  Reactter.delete<Counter>();

  // Can't find the dependency instance, because the dependency register was deleted
  final counter2 = Reactter.find<Counter>();
  print("counter2: ${counter2?.hashCode}"); // counter2: null

  // Create a dependency
  Reactter.create<Counter>(() => Counter(), id: 'CounterById');

  // Find the dependency using `id` parameter
  final counterById = Reactter.find<Counter>('CounterById');
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency using `id` parameter
  Reactter.delete<Counter>('CounterById');

  // Can't find the dependency instance using `id` parameter, because the dependency register was deleted
  final counterById2 = Reactter.find<Counter>('CounterById');
  print("counterById2: ${counterById2?.hashCode}"); // counter2: null

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
