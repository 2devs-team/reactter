import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide the `CounterController` dependency to the widget tree
    return RtProvider<CounterController>.lazy(
      () {
        print('CounterController created');
        return CounterController();
      },
      builder: (context, child) {
        final showCounter = Signal(false);

        return RtSignalWatcher(
          builder: (context, child) {
            if (!showCounter.value) {
              return ElevatedButton(
                onPressed: () => showCounter.value = true,
                child: const Text('Show Counter'),
              );
            }

            // In this line, the `CounterController` instance will be created
            final counterController = context.use<CounterController>();

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
                RtConsumer<CounterController>(
                  listenStates: (counterController) =>
                      [counterController.count],
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
      },
    );
  }
}
