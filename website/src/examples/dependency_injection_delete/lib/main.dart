import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'counter.dart';

void main() {
  // Create the dependencies with different dependency modes
  final counter = Rt.create<Counter>(() => Counter());
  final counter2 = Rt.builder<Counter>(() => Counter(), id: 'Builder');
  final counter3 = Rt.factory<Counter>(() => Counter(), id: 'Factory');
  final counter4 = Rt.singleton<Counter>(
    () => Counter(),
    id: 'Singleton',
  );

  // Delete the dependencies
  final isDeleted = Rt.delete<Counter>();
  final isDeleted2 = Rt.delete<Counter>('Builder');
  final isDeleted3 = Rt.delete<Counter>('Factory');
  final isDeleted4 = Rt.delete<Counter>('Singleton');

  // Print if the dependencies are deleted
  print('isDeleted: $isDeleted'); // isDeleted: true
  print('isDeleted2: $isDeleted2'); // isDeleted2: true
  print('isDeleted3: $isDeleted3'); // isDeleted3: true
  print('isDeleted4: $isDeleted4'); // isDeleted4: false

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
  print('isObtained: $isObtained'); // isObtained: false
  print('isObtained2: $isObtained2'); // isObtained2: false
  print('isObtained3: $isObtained3'); // isObtained3: true
  print('isObtained4: $isObtained4'); // isObtained4: true

  // Check if the dependencies are the same instance
  final isSameInstance = counter == counterAfterDeleted;
  final isSameInstance2 = counter2 == counterAfterDeleted2;
  final isSameInstance3 = counter3 == counterAfterDeleted3;
  final isSameInstance4 = counter4 == counterAfterDeleted4;

  // Print if the dependencies are the same instance
  print('isSameInstance: $isSameInstance'); // isSameInstance: false
  print('isSameInstance2: $isSameInstance2'); // isSameInstance2: false
  print('isSameInstance3: $isSameInstance3'); // isSameInstance3: false
  print('isSameInstance4: $isSameInstance4'); // isSameInstance4: true

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
