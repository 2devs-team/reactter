import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Register a dependency
  Rt.register<Counter>(() => Counter());

  // Get the dependency
  final counter = Rt.get<Counter>();
  print("counter: ${counter?.hashCode}");

  // Delete the dependency
  Rt.delete<Counter>();

  // Can't get the dependency instance, because the dependency register was deleted
  final counter2 = Rt.get<Counter>();
  print("counter2: ${counter2?.hashCode}"); // counter2: null

  // Register a dependency
  Rt.register<Counter>(() => Counter(), id: 'CounterById');

  // Get the dependency using `id` parameter
  final counterById = Rt.get<Counter>('CounterById');
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency using `id` parameter
  Rt.delete<Counter>('CounterById');

  // Can't get the dependency instance using `id` parameter, because the dependency register was deleted
  final counterById2 = Rt.get<Counter>('CounterById');
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
