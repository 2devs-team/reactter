import 'package:flutter/material.dart';
import 'counter.dart';

class CounterWithButtons extends StatelessWidget {
  const CounterWithButtons({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Counter(
      builder: (context, counterController, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: counterController.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8),
                if (child != null) child,
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: counterController.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
