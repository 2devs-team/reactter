import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'my_dependency.dart';

void main() {
  // Listen to the `myEvent` event of the `MyDependency` before it's created.
  Reactter.one(
    ReactterDependency<MyDependency>(),
    CustomEvent.myEvent,
    (instance, param) => print('CustomEvent emitted with param: $param'),
  );

  // Create a new instance of `MyDependency`.
  final myDependency = Reactter.create(() => MyDependency())!;

  // Listen to the `didUpdate` event of the `MyDependency` instance.
  Reactter.one<MyDependency, ReactterState>(
    myDependency,
    Lifecycle.didUpdate,
    (instance, state) => print('The state updated is: ${state.runtimeType}'),
  );

  // Listen to the `didUpdate` event of the `stateA`.
  Reactter.one(
    myDependency.stateA,
    Lifecycle.didUpdate,
    (instance, Signal state) => print('stateA updated: ${state.value}'),
  );

  // Listen to the `didUpdate` event of the `stateB`.
  Reactter.one(
    myDependency.stateB,
    Lifecycle.didUpdate,
    (instance, Signal state) => print('stateB updated: ${state.value}'),
  );

  // Change the value of `stateA` to `10`.
  // Print:
  //  stateA updated: 10
  // The state updated is: Signal<int>
  myDependency.stateA.value = 10;

  // Change the value of `stateB` to `'Hello World!'`.
  // No print for the `didUpdate` event of `MyDependency` instance
  // because it's a one-time listener.
  // Print:
  //  stateB updated: 'Hello World!'
  myDependency.stateB.value = 'Hello World!';

  // Emit the `myEvent` event with the parameter `test`.
  // Print:
  //  CustomEvent.myEvent emitted with param: test
  Reactter.emit(myDependency, CustomEvent.myEvent, 'test');

  // Delete the `MyDependency` instance
  Reactter.delete<MyDependency>();

  // Cannot listen to the `didUpdate` event of the `MyDependency` instance
  // because it's deleted. This will throw an error.
  // myDependency.stateA.value = 20;

  /// Cannot listen to the `myEvent` event using the `MyDependency` instance
  /// because the listener is one-time.
  Reactter.emit(ReactterDependency<MyDependency>(), CustomEvent.myEvent, 42);

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
