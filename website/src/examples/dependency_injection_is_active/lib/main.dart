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

  // Check if the instances are registered
  final isActive = Rt.isActive(counter);
  final isActive2 = Rt.isActive(counter2);
  final isActive3 = Rt.isActive(counter3);
  final isActive4 = Rt.isActive(counter4);

  // Print if the instances are registered
  print('isActive: $isActive'); // isActive: false
  print('isActive2: $isActive2'); // isActive2: true
  print('isActive3: $isActive3'); // isActive3: true
  print('isActive4: $isActive4'); // isActive4: true

  // Delete the dependencies
  Rt.destroy<Counter>(onlyInstance: true);
  Rt.delete<Counter>('Builder');
  Rt.delete<Counter>('Factory');
  Rt.delete<Counter>('Singleton');

  // Check if the instances are registered
  final isActiveAfterDeleted = Rt.isActive(counter);
  final isActiveAfterDeleted2 = Rt.isActive(counter2);
  final isActiveAfterDeleted3 = Rt.isActive(counter3);
  final isActiveAfterDeleted4 = Rt.isActive(counter4);

  // Print if the instances are registere after deleted
  print(
    'isActiveAfterDeleted: $isActiveAfterDeleted',
  ); // isActiveAfterDeleted: false
  print(
    'isActiveAfterDeleted2: $isActiveAfterDeleted2',
  ); // isActiveAfterDeleted2: false
  print(
    'isActiveAfterDeleted3: $isActiveAfterDeleted3',
  ); // isActiveAfterDeleted3: false
  print(
    'isActiveAfterDeleted4: $isActiveAfterDeleted4',
  ); // isActiveAfterDeleted4: true

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
