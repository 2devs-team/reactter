import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'my_dependency.dart';

void main() {
  // Listen to the `myEvent` event of the `MyDependency` before it's created.
  Rt.on(
    RtDependencyRef<MyDependency>(),
    CustomEvent.myEvent,
    (instance, param) => print('CustomEvent emitted with param: $param'),
  );

  // Create a new instance of `MyDependency`.
  final myDependency = Rt.create(() => MyDependency())!;

  // Listen to the `didUpdate` event of the `MyDependency` instance.
  Rt.on<MyDependency, RtState>(
    myDependency,
    Lifecycle.didUpdate,
    (instance, state) => print('The state updated is: ${state.runtimeType}'),
  );

  // Listen to the `didUpdate` event of the `stateA`.
  Rt.on(
    myDependency.stateA,
    Lifecycle.didUpdate,
    (instance, Signal state) => print('stateA updated: ${state.value}'),
  );

  // Listen to the `didUpdate` event of the `stateB`.
  Rt.on(
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
  Rt.emit(myDependency, CustomEvent.myEvent, 'test');

  // Delete the `MyDependency` instance
  Rt.delete<MyDependency>();

  // Cannot listen to the `didUpdate` event of the `MyDependency` instance
  // because it's deleted. This will throw an error.
  // myDependency.stateA.value = 20;

  // Cannot listen to the `myEvent` event using the `MyDependency` instance
  // because it's deleted.
  Rt.emit(myDependency, CustomEvent.myEvent, 'This is not printed');

  // Can still emit to the `myEvent` event using the `RtDependencyRef`
  // Print:
  //  CustomEvent.myEvent emitted with param: 42
  Rt.emit(RtDependencyRef<MyDependency>(), CustomEvent.myEvent, 42);

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
