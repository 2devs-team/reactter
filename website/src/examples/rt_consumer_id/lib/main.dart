import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_view.dart';
import 'counter_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RtMultiProvider(
        [
          RtProvider(() => CounterController(), id: 'counter1'),
          RtProvider(() => CounterController(), id: 'counter2'),
        ],
        builder: (context, child) {
          return CounterView();
        },
      ),
    );
  }
}
