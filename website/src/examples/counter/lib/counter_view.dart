import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class CounterView extends StatelessWidget {
  const CounterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      // Provides the `CounterController` dependency to the widget tree
      body: ReactterProvider<CounterController>(
        () => CounterController(), // Registers the `CounterController` dependency
        builder: (context, counterController, child) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: counterController.decrement,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 8),
              ReactterConsumer<CounterController>(
                // Observes the `count` property of the `counterController` instance
                listenStates: (counterController) => [counterController.count],
                builder: (context, counterController, child) {
                  // Rebuilds the widget tree when the `count` value changes
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
      ),
    );
  }
}