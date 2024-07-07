import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create the dependencies with different dependency modes
  final counter = Counter();
  final counter2 = Reactter.builder<Counter>(() => Counter(), id: 'Builder');
  final counter3 = Reactter.factory<Counter>(() => Counter(), id: 'Factory');
  final counter4 = Reactter.singleton<Counter>(
    () => Counter(),
    id: 'Singleton',
  );

  // Check if the instances are registered
  final isRegistered = Reactter.isRegistered(counter);
  final isRegistered2 = Reactter.isRegistered(counter2);
  final isRegistered3 = Reactter.isRegistered(counter3);
  final isRegistered4 = Reactter.isRegistered(counter4);

  // Print if the instances are registered
  print('isRegistered: $isRegistered'); // isRegistered: false
  print('isRegistered2: $isRegistered2'); // isRegistered2: true
  print('isRegistered3: $isRegistered3'); // isRegistered3: true
  print('isRegistered4: $isRegistered4'); // isRegistered4: true

  // Delete the dependencies
  Reactter.destroy<Counter>(onlyInstance: true);
  Reactter.delete<Counter>('Builder');
  Reactter.delete<Counter>('Factory');
  Reactter.delete<Counter>('Singleton');

  // Check if the instances are registered
  final isRegisteredAfterDeleted = Reactter.isRegistered(counter);
  final isRegisteredAfterDeleted2 = Reactter.isRegistered(counter2);
  final isRegisteredAfterDeleted3 = Reactter.isRegistered(counter3);
  final isRegisteredAfterDeleted4 = Reactter.isRegistered(counter4);

  // Print if the instances are registere after deleted
  print(
    'isRegisteredAfterDeleted: $isRegisteredAfterDeleted',
  ); // isRegisteredAfterDeleted: false
  print(
    'isRegisteredAfterDeleted2: $isRegisteredAfterDeleted2',
  ); // isRegisteredAfterDeleted2: false
  print(
    'isRegisteredAfterDeleted3: $isRegisteredAfterDeleted3',
  ); // isRegisteredAfterDeleted3: false
  print(
    'isRegisteredAfterDeleted4: $isRegisteredAfterDeleted4',
  ); // isRegisteredAfterDeleted4: true

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
