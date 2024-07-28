import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/2_calculator/controllers/calculator_controller.dart';

class CalculatorResult extends StatelessWidget {
  const CalculatorResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculatorController = context.use<CalculatorController>();

    return Container(
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.bottomRight,
      child: RtWatcher((context) {
        return Text(
          "${calculatorController.result}",
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w200,
          ),
        );
      }),
    );
  }
}
