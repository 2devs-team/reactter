import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create the dependencies with different dependency modes
  Rt.create<Counter>(() => Counter());
  Rt.builder<Counter>(() => Counter(), id: 'Builder');
  Rt.factory<Counter>(() => Counter(), id: 'Factory');
  Rt.singleton<Counter>(() => Counter(), id: 'Singleton');

  // Delete the dependencies
  final isDestroyed = Rt.destroy<Counter>(onlyInstance: true);
  final isDestroyed2 = Rt.destroy<Counter>(id: 'Builder');
  final isDestroyed3 = Rt.destroy<Counter>(id: 'Factory');
  final isDestroyed4 = Rt.destroy<Counter>(id: 'Singleton');

  // Print if the dependencies are destroyed
  print('isDestroyed: $isDestroyed'); // isDestroyed: false
  print('isDestroyed2: $isDestroyed2'); // isDestroyed2: true
  print('isDestroyed3: $isDestroyed3'); // isDestroyed3: true
  print('isDestroyed4: $isDestroyed4'); // isDestroyed4: true

  // Get the dependencies
  final counterAfterDeleted = Rt.get<Counter>();
  final counterAfterDeleted2 = Rt.get<Counter>('Builder');
  final counterAfterDeleted3 = Rt.get<Counter>('Factory');
  final counterAfterDeleted4 = Rt.get<Counter>('Singleton');

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
