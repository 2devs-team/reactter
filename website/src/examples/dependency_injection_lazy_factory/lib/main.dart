import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Register a dependency as factory mode.
  Reactter.lazyFactory<Counter>(() => Counter());

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

  // Can get the dependency instance, but it's created again, because it's factory mode
  final counter2 = Reactter.get<Counter>();
  print("counter2: ${counter2?.hashCode}");

  // Delete the dependency instance and its register
  Reactter.destroy<Counter>();

  // Can't get the dependency instance, because the dependency register was deleted using `destroy` method
  final counter3 = Reactter.get<Counter>();
  print("counter3: ${counter3?.hashCode}"); // counter3: null

  // Register a dependency using `id` parameter as factory mode
  Reactter.lazyFactory(() => Counter(), id: 'CounterById');

  // Get the dependency using `id` parameter
  final counterById = Reactter.get<Counter>('CounterById');
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency instance and its register using `id` parameter
  Reactter.destroy<Counter>(id: 'CounterById');

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
