import 'package:flutter_reactter/flutter_reactter.dart';

class CounterController {
  final count = Signal(0);

  CounterController() {
    Rt.on(this, Lifecycle.willMount, (_, __) {
      print('CounterController will mount');
    });

    Rt.on(this, Lifecycle.didMount, (_, __) {
      print('CounterController did mount');
    });

    Rt.on(this, Lifecycle.willUpdate, (_, state) {
      print('CounterController will update by ${state.runtimeType}');
    });

    Rt.on(this, Lifecycle.didUpdate, (_, state) {
      print('CounterController did updated by ${state.runtimeType}');
    });

    Rt.on(this, Lifecycle.willUnmount, (_, __) {
      print('CounterController will unmount');
    });

    Rt.on(this, Lifecycle.didUnmount, (_, __) {
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
