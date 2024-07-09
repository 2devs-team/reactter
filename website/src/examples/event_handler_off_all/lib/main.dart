import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'my_dependency.dart';

void main() {
  // Listen to the `myEvent` event of the `MyDependency` before it's created.
  Reactter.on(
    ReactterDependency<MyDependency>(),
    CustomEvent.myEvent,
    (instance, param) => print('CustomEvent emitted with param: $param'),
  );

  // Create a new instance of `MyDependency`.
  final myDependency = Reactter.create(() => MyDependency())!;

  // Listen to the `didUpdate` event of the `MyDependency` instance.
  Reactter.on<MyDependency, ReactterState>(
    myDependency,
    Lifecycle.didUpdate,
    (instance, state) => print('The state updated is: ${state.runtimeType}'),
  );

  // Listen to the `didUpdate` event of the `stateA`.
  Reactter.on(
    myDependency.stateA,
    Lifecycle.didUpdate,
    (instance, Signal state) => print('stateA updated: ${state.value}'),
  );

  // Listen to the `didUpdate` event of the `stateB`.
  Reactter.on(
    myDependency.stateB,
    Lifecycle.didUpdate,
    (instance, Signal state) => print('stateB updated: ${state.value}'),
  );

  // Change the value of `stateA` to `10`.
  // Print:
  //  stateA updated: 10
  //  The state updated is: Signal<int>
  myDependency.stateA.value = 10;

  // Change the value of `stateB` to `'Hello World!'`.
  // Print:
  //  stateB updated: 'Hello World!'
  //  The state updated is: Signal<String>
  myDependency.stateB.value = 'Hello World!';

  // Emit the `myEvent` event with the parameter `test`.
  // Print:
  //  CustomEvent.myEvent emitted with param: test
  Reactter.emit(myDependency, CustomEvent.myEvent, 'test');

  // Remove all event listeners of `stateA`.
  Reactter.offAll(myDependency.stateA);

  // Remove all event listeners of `myDependency`,
  // including the generic listeners (using `ReactterDependency`).
  Reactter.offAll(myDependency, true);

  // No print for neither `stateA` nor the `MyDependency` instance
  // because the listeners are removed
  myDependency.stateA.value = 20;

  // Change the value of `stateB` to `Hey you!'`.
  // Only print for the `didUpdate` event of `stateB`.
  // Print:
  //  stateB updated: 'Hey you!'
  myDependency.stateB.value = 'Hey you!';

  // Cannot listen to the `myEvent` event using the `MyDependency` instance
  // because the listeners are removed.
  Reactter.emit(myDependency, CustomEvent.myEvent, 'This is not printed');

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
