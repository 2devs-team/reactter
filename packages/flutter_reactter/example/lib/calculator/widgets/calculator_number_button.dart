import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'button.dart';
import '../controllers/calculator_controller.dart';

class CalculatorNumberButton extends StatelessWidget {
  const CalculatorNumberButton({Key? key, required this.number})
      : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    final calculatorController = context.use<CalculatorController>();

    return Expanded(
      flex: number == 0 ? 2 : 1,
      child: Button.tertiary(
        label: "$number",
        onPressed: () => calculatorController.executeAction(
          ActionCalculator.number,
          number,
        ),
      ),
    );
  }
}
