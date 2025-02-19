import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';
import 'my_dependency.dart';

void onMyEvent(instance, param) {
  print('CustomEvent emitted with param: $param');
}

void onDidUpdate(instance, state) {
  print('The state updated is: ${state.runtimeType}');
}

void onDidUpdateStateA(instance, Signal state) {
  print('stateA updated: ${state.value}');
}

void onDidUpdateStateB(instance, Signal state) {
  print('stateB updated: ${state.value}');
}

void main() {
  // Listen to the `myEvent` event of the `MyDependency` before it's created.
  Rt.on(
    RtDependencyRef<MyDependency>(),
    CustomEvent.myEvent,
    onMyEvent,
  );

  // Create a new instance of `MyDependency`.
  final myDependency = Rt.create(() => MyDependency())!;

  // Listen to the `didUpdate` event of the `MyDependency` instance.
  Rt.on<MyDependency, RtState>(
    myDependency,
    Lifecycle.didUpdate,
    onDidUpdate,
  );

  // Listen to the `didUpdate` event of the `stateA`.
  Rt.on(myDependency.stateA, Lifecycle.didUpdate, onDidUpdateStateA);

  // Listen to the `didUpdate` event of the `stateB`.
  Rt.on(myDependency.stateB, Lifecycle.didUpdate, onDidUpdateStateB);

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

  // Stop listening to the `myEvent` event of the `MyDependency`
  Rt.off(
    RtDependencyRef<MyDependency>(),
    CustomEvent.myEvent,
    onMyEvent,
  );

  // Stop listening to the `didUpdate` event of the `MyDependency` instance
  Rt.off(myDependency, Lifecycle.didUpdate, onDidUpdate);

  // Stop listening to the `didUpdate` event of the `stateA`
  Rt.off(myDependency.stateA, Lifecycle.didUpdate, onDidUpdateStateA);

  // No print for neither `stateA` nor the `MyDependency` instance
  // because the listeners are removed
  myDependency.stateA.value = 20;

  // Cannot listen to the `myEvent` event using the `MyDependency` instance
  // because the listener is removed
  Rt.emit(myDependency, CustomEvent.myEvent, 'This is not printed');

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
