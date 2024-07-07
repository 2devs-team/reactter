import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create a dependency
  Reactter.create<Counter>(() => Counter());

  // Check if the dependency exists
  final isExists = Reactter.exists<Counter>();
  print("Counter exists: $isExists"); // Counter exists: true

  // Delete the dependency
  Reactter.delete<Counter>();

  // Check if the dependency exists after deleting it
  final isExists2 = Reactter.exists<Counter>();
  print(
    "Counter exists after deleting: $isExists2",
  ); // Counter exists after deleting: false

  // Create a dependency using `id` parameter
  Reactter.create<Counter>(() => Counter(), id: 'CounterById');

  // Check if the dependency exists using `id` parameter
  final isExistsById = Reactter.exists<Counter>('CounterById');
  print("Counter by id exists: $isExistsById"); // Counter by id exists: true

  // Delete the dependency using `id` parameter
  Reactter.delete<Counter>('CounterById');

  // Check if the dependency exists after deleting it using `id` parameter
  final isExistsById2 = Reactter.exists<Counter>('CounterById');
  print(
    "Counter by id exists after deleting: $isExistsById2",
  ); // Counter by id exists after deleting: false

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
