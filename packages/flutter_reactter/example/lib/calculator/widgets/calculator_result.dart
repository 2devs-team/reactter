import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../controllers/calculator_controller.dart';

class CalculatorResult extends StatelessWidget {
  const CalculatorResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculatorController = context.use<CalculatorController>();

    return ReactterWatcher(
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.bottomRight,
          child: Text(
            "${calculatorController.result}",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w200,
            ),
          ),
        );
      },
    );
  }
}
