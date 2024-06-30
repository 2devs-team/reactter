import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Immediately initializes the `CounterController` dependency for providing it to the widget tree
    final widgetToRender = ReactterProvider<CounterController>.init(
      () {
        print('CounterController created');
        return CounterController();
      },
      builder: (context, counterController, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: counterController.decrement,
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 8),
            // Observes the `count` property of the `counterController`
            // and rebuilds the widget tree when the `count` value changes
            ReactterConsumer<CounterController>(
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

    // The `CounterController` instance can be use here
    // to call methods or access properties
    Reactter.get<CounterController>()?.count.value = 10;

    // A render delay of 10 seconds
    return FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 10),
          () => widgetToRender,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data as Widget;
        });
  }
}
