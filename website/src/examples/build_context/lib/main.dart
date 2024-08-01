import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'counter_controller.dart';
import 'counter_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RtMultiProvider(
        [
          RtProvider(() => CounterController()),
          RtProvider.lazy(() => CounterController(), id: 'counterLazy'),
        ],
        child: CounterView(),
      ),
    );
  }
}
