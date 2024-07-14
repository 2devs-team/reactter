import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter.dart';
import 'counter_controller.dart';

class CounterWithButtons extends ReactterComponent<CounterController> {
  const CounterWithButtons({Key? key, this.id}) : super(key: key);

  // Identify the `CounterController` dependency
  @override
  final String? id;

  // Provide the `CounterController` dependency to the widget tree
  @override
  get builder => () => CounterController();

  @override
  Widget render(context, counterController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: counterController.decrement,
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 8),
        Counter(id: id),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: counterController.increment,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
