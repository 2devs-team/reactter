import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Register a dependency
  Rt.register<Counter>(() => Counter());

  // Get the dependency
  final counter = Rt.get<Counter>();
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

  // Register a dependency using `id` parameter
  Rt.register(() => Counter(), id: 'CounterById');

  // Get the dependency using `id` parameter
  final counterById = Rt.get<Counter>('CounterById');
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency using `id` parameter
  Rt.delete<Counter>('CounterById');

  // Register a dependency using `mode` parameter as singleton mode
  Rt.register(() => Counter(), mode: DependencyMode.singleton);

  // Get the dependency
  final counterBySingletonMode = Rt.get<Counter>();
  print("counterBySingletonMode: ${counterBySingletonMode?.hashCode}");

  // Delete the dependency
  Rt.delete<Counter>();

  // Can get the dependency again, because it's singleton mode
  final counterBySingletonMode2 = Rt.get<Counter>();
  print(
    "counterBySingletonMode2: ${counterBySingletonMode2?.hashCode}",
  );

  // Use `onlyInstance` parameter to delete the dependency instance only
  Rt.destroy<Counter>(onlyInstance: true);

  // Can't get the dependency instance, because the dependency register was destroyed
  final counterBySingletonMode3 = Rt.find<Counter>();
  print(
    "counterBySingletonMode3: ${counterBySingletonMode3?.hashCode}",
  ); // counterBySingletonMode3: null

  // If you need to delete the dependency fully, use `Rt.destroy` method by forcing it, because it's singleton mode
  Rt.destroy<Counter>();

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
