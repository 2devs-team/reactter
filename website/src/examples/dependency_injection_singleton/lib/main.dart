import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create a dependency as singleton mode.
  final counter = Rt.singleton<Counter>(() => Counter());
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

  // Can't delete the dependency, because it's singleton mode
  Rt.delete<Counter>();

  // Can update the state, because it's singleton mode
  counter.increment();

  // Can get the same dependency instanse, because it's singleton mode
  final counter2 = Rt.get<Counter>();
  print("counter2: ${counter2?.hashCode}");

  // Delete the dependency instance
  Rt.destroy<Counter>(onlyInstance: true);

  // Can get the dependency instance, but it's created again, because it's singleton mode
  final counter3 = Rt.get<Counter>();
  print("counter3: ${counter3?.hashCode}");

  // Delete the dependency instance and its register
  Rt.destroy<Counter>();

  // Can't get the dependency instance, because the dependency register was deleted using `destroy` method
  final counter4 = Rt.get<Counter>();
  print("counter4: ${counter4?.hashCode}"); // counter4: null

  // Create a dependency using `id` parameter as singleton mode
  final counterById = Rt.singleton(() => Counter(), id: 'CounterById');
  print("counterById: ${counterById?.hashCode}");

  // Delete the dependency instance and its register using `id` parameter
  Rt.destroy<Counter>(id: 'CounterById');

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
