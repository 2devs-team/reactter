import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create the dependencies with different dependency modes
  final counter = Counter();
  final counter2 = Rt.builder<Counter>(() => Counter(), id: 'Builder');
  final counter3 = Rt.factory<Counter>(() => Counter(), id: 'Factory');
  final counter4 = Rt.singleton<Counter>(
    () => Counter(),
    id: 'Singleton',
  );

  // Check the dependency modes
  final counterMode = Rt.getDependencyMode(counter);
  final counter2Mode = Rt.getDependencyMode(counter2);
  final counter3Mode = Rt.getDependencyMode(counter3);
  final counter4Mode = Rt.getDependencyMode(counter4);

  print(
    'Counter mode: $counterMode',
  ); // Counter mode: null
  print(
    'Counter2 mode: $counter2Mode',
  ); // Counter2 mode: DependencyMode.builder
  print(
    'Counter3 mode: $counter3Mode',
  ); // Counter3 mode: DependencyMode.factory
  print(
    'Counter4 mode: $counter4Mode',
  ); // Counter4 mode: DependencyMode.singleton

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
