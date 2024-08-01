import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create the dependencies with different dependency modes
  Rt.create<Counter>(() => Counter());
  Rt.builder<Counter>(() => Counter(), id: 'Builder');
  Rt.factory<Counter>(() => Counter(), id: 'Factory');
  Rt.singleton<Counter>(() => Counter(), id: 'Singleton');

  // Unregister the dependencies
  final isUnregistered = Rt.unregister<Counter>();
  final isUnregistered2 = Rt.unregister<Counter>('Builder');
  final isUnregistered3 = Rt.unregister<Counter>('Factory');
  final isUnregistered4 = Rt.unregister<Counter>('Singleton');

  // All should return false, because the dependencies has an active instance
  print('isUnregistered: $isUnregistered'); // isUnregistered: false
  print('isUnregistered2: $isUnregistered2'); // isUnregistered2: false
  print('isUnregistered3: $isUnregistered3'); // isUnregistered3: false
  print('isUnregistered4: $isUnregistered4'); // isCounterUnregistered4: false

  // Delete the dependencies
  Rt.destroy<Counter>(onlyInstance: true);
  Rt.delete<Counter>('Builder');
  Rt.delete<Counter>('Factory');
  Rt.delete<Counter>('Singleton');

  // Unregister the dependencies after deleted
  final isUnregisteredAfterDeleted = Rt.unregister<Counter>();
  final isUnregisteredAfterDeleted2 = Rt.unregister<Counter>('Builder');
  final isUnregisteredAfterDeleted3 = Rt.unregister<Counter>('Factory');
  final isUnregisteredAfterDeleted4 = Rt.unregister<Counter>('Singleton');

  // These should return true, because the instance has been deleted but the dependency is still registered
  print(
    'isUnregisteredAfterDeleted: $isUnregisteredAfterDeleted',
  ); // isUnregisteredAfterDeleted: true
  print(
    'isUnregisteredAfterDeleted3: $isUnregisteredAfterDeleted3',
  ); // isUnregisteredAfterDeleted3: true

  // These should return false, because the instance and its registration has been deleted
  print(
    'isUnregisteredAfterDeleted2: $isUnregisteredAfterDeleted2',
  ); // isUnregisteredAfterDeleted2: false
  print(
    'isUnregisteredAfterDeleted4: $isUnregisteredAfterDeleted4',
  ); // isUnregisteredAfterDeleted4: false

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
