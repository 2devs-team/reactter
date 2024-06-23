import 'package:flutter_reactter/flutter_reactter.dart';

class CounterController {
  final count = Signal(0);

  CounterController() {
    Reactter.on(this, Lifecycle.willMount, (_, __) {
      print('CounterController will mount');
    });

    Reactter.on(this, Lifecycle.didMount, (_, __) {
      print('CounterController did mount');
    });

    Reactter.on(this, Lifecycle.willUpdate, (_, state) {
      print('CounterController will update by ${state.runtimeType}');
    });

    Reactter.on(this, Lifecycle.didUpdate, (_, state) {
      print('CounterController did updated by ${state.runtimeType}');
    });

    Reactter.on(this, Lifecycle.willUnmount, (_, __) {
      print('CounterController will unmount');
    });

    Reactter.on(this, Lifecycle.didUnmount, (_, __) {
      print('CounterController did unmount');
    });
  }

  void increment() {
    count.value++;
  }

  void decrement() {
    count.value--;
  }
}
