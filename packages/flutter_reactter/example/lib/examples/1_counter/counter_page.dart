// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

final count = Signal(0);

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
      ),
      body: Center(
        child: Wrap(
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => count.value--,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.red,
                padding: EdgeInsets.all(8),
              ),
              child: Icon(Icons.remove, color: Colors.white),
            ),
            Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).highlightColor,
              ),
              child: FittedBox(
                child: RtWatcher((context) {
                  return Text(
                    "$count",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () => count.value++,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.green,
                padding: EdgeInsets.all(8),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
