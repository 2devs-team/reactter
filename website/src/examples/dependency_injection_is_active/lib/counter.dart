import 'package:reactter/reactter.dart';

class Counter {
  // Create a reactive state using the `Signal` class
  final count = Signal(0);

  void increment() {
    count.value++;
  }

  void decrement() {
    count.value--;
  }
}
