import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Locale the `CounterController` dependency
    return RtConsumer<CounterController>(
      builder: (context, counterController, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: counterController.decrement,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
            // Listens to all states provided by the `CounterController` dependency
            // and rebuilds whenever there are changes any state of the `CounterController` dependency
            RtConsumer<CounterController>(
              listenAll: true,
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
