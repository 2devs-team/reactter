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
      home: ReactterProviders(
        [
          ReactterProvider(() => CounterController()),
          ReactterProvider.lazy(() => CounterController(), id: 'counterLazy'),
        ],
        child: CounterView(),
      ),
    );
  }
}
