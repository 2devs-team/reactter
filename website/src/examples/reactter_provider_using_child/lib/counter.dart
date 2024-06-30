import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends StatelessWidget {
  final InstanceChildBuilder<CounterController>? builder;

  const Counter({Key? key, this.builder}) : super(key: key);

  Widget build(BuildContext context) {
    // Provides the `CounterController` dependency to the widget tree
    return ReactterProvider<CounterController>(
      () => CounterController(), // Registers the `CounterController` dependency
      child: ReactterConsumer<CounterController>(
        // Observes the `count` property of the `counterController` instance
        listenStates: (counterController) => [counterController.count],
        builder: (context, counterController, child) {
          // Rebuilds the widget tree when the `count` value changes
          return Text("${counterController.count}");
        },
      ),
      builder: builder,
    );
  }
}