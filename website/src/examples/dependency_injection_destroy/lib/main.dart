import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create the dependencies with different dependency modes
  Reactter.create<Counter>(() => Counter());
  Reactter.builder<Counter>(() => Counter(), id: 'Builder');
  Reactter.factory<Counter>(() => Counter(), id: 'Factory');
  Reactter.singleton<Counter>(() => Counter(), id: 'Singleton');

  // Delete the dependencies
  final isDestroyed = Reactter.destroy<Counter>(onlyInstance: true);
  final isDestroyed2 = Reactter.destroy<Counter>(id: 'Builder');
  final isDestroyed3 = Reactter.destroy<Counter>(id: 'Factory');
  final isDestroyed4 = Reactter.destroy<Counter>(id: 'Singleton');

  // Print if the dependencies are destroyed
  print('isDestroyed: $isDestroyed'); // isDestroyed: false
  print('isDestroyed2: $isDestroyed2'); // isDestroyed2: true
  print('isDestroyed3: $isDestroyed3'); // isDestroyed3: true
  print('isDestroyed4: $isDestroyed4'); // isDestroyed4: true

  // Get the dependencies
  final counterAfterDeleted = Reactter.get<Counter>();
  final counterAfterDeleted2 = Reactter.get<Counter>('Builder');
  final counterAfterDeleted3 = Reactter.get<Counter>('Factory');
  final counterAfterDeleted4 = Reactter.get<Counter>('Singleton');

  // Check if the dependencies are obtained
  final isObtained = counterAfterDeleted != null;
  final isObtained2 = counterAfterDeleted2 != null;
  final isObtained3 = counterAfterDeleted3 != null;
  final isObtained4 = counterAfterDeleted4 != null;

  // Print if the dependencies are obtained
  print('isObtained: $isObtained'); // isObtained: true
  print('isObtained2: $isObtained2'); // isObtained2: false
  print('isObtained3: $isObtained3'); // isObtained3: false
  print('isObtained4: $isObtained4'); // isObtained4: false

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
