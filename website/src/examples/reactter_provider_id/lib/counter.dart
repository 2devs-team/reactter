import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends StatelessWidget {
  final String? id;

  const Counter({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide the `CounterController` dependency to the widget tree
    return ReactterProvider<CounterController>(
      () => CounterController(),
      id: id,
      builder: (context, counterController, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: counterController.decrement,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
            // Observe the `count` property of the `counterController`
            // and rebuild the widget tree when the `count` value changes
            ReactterConsumer<CounterController>(
              id: id,
              listenStates: (counterController) => [counterController.count],
              builder: (context, counterController, child) {
                return Text("${counterController.count}");
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: counterController.increment,
              child: const Icon(Icons.add),
            ),
          ],
        );
      },
    );
  }
}
