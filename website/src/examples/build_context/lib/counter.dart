import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    // Locale the `CounterController` dependency
    final counterController = context.use<CounterController>(id);

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
        Builder(
          builder: (context) {
            if (id != null) {
              context.watchId<CounterController>(id!, (inst) => [inst.count]);
            } else {
              context.watch<CounterController>((inst) => [inst.count]);
            }

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
  }
}
