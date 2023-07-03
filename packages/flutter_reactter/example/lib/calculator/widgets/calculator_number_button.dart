import 'package:examples/calculator/widgets/button.dart';
import 'package:examples/calculator/controllers/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CalculatorNumberButton extends StatelessWidget {
  const CalculatorNumberButton({Key? key, required this.number})
      : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    final calculatorController = context.use<CalculatorController>();

    return Expanded(
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
