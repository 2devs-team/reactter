import 'package:examples/examples/2_calculator/controllers/calculator_controller.dart';
import 'package:examples/examples/2_calculator/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CalculatorNumberButton extends StatelessWidget {
  const CalculatorNumberButton({Key? key, required this.number, this.flex = 1})
      : super(key: key);

  final int number;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final calculatorController = context.use<CalculatorController>();

    return Expanded(
      flex: flex,
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
