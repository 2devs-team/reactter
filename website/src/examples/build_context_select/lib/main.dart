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
      // Provide the `CounterController` dependency to the widget tree
      home: RtProvider.lazy(
        () => CounterController(),
        builder: (context, child) {
          return CounterView();
        },
      ),
    );
  }
}
