import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends ReactterComponent<CounterController> {
  const Counter({Key? key, this.id}) : super(key: key);

  // Identify the `CounterController` dependency
  @override
  final String? id;

  // Provide the `CounterController` dependency to the widget tree
  @override
  get builder => () => CounterController();

  // Observe the `count` property of the `counterController`
  // and rebuild the widget tree when the `count` value changes
  @override
  get listenStates => (counterController) => [counterController.count];

  @override
  Widget render(context, counterController) {
    return Text("${counterController.count}");
  }
}
