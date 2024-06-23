import 'package:flutter_reactter/flutter_reactter.dart';

class CounterController {
  final count = Signal(0);

  CounterController() {
    UseEffect(() {
      print('CounterController mounted');

      return () {
        print('CounterController will unmount');
      };
    }, []);

    UseEffect(() {
      print(
        "CounterController's count changed to ${count.value}",
      );
    }, [count]);
  }

  void increment() {
    count.value++;
  }

  void decrement() {
    count.value--;
  }
}
