import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = Signal(0);

    return ReactterWatcher(
      // This widget remains static and does not rebuild when `count` changes.
      // It is passed as a `child` to the `builder` function.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Icon(Icons.remove),
            onPressed: () => count.value--,
          ),
          SizedBox(width: 8),
          ElevatedButton(
            child: const Icon(Icons.add),
            onPressed: () => count.value++,
          ),
        ],
      ),
      // Rebuid the widget when `count` changes
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Count: $count"),
            SizedBox(height: 8),
            child!,
          ],
        );
      },
    );
  }
}
