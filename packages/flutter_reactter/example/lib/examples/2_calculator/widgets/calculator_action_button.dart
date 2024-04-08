import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/2_calculator/widgets/button.dart';
import 'package:examples/examples/2_calculator/controllers/calculator_controller.dart';

final actionLabel = {
  ActionCalculator.add: '+',
  ActionCalculator.clear: 'C',
  ActionCalculator.divide: '÷',
  ActionCalculator.equal: '=',
  ActionCalculator.multiply: '×',
  ActionCalculator.point: '.',
  ActionCalculator.porcentage: '%',
  ActionCalculator.sign: '+/–',
  ActionCalculator.subtract: '–',
};

class CalculatorActionButton extends StatelessWidget {
  const CalculatorActionButton({
    Key? key,
    required this.action,
  }) : super(key: key);

  final ActionCalculator action;

  @override
  Widget build(BuildContext context) {
    final calculatorController = context.use<CalculatorController>();
    final isMathOperation = mathOperationMethods.keys.contains(action);
    final label = actionLabel[action] ?? 'N/A';

    void onPressed() => calculatorController.executeAction(action);

    if (isMathOperation) {
      return Expanded(
        child: ReactterSelector<CalculatorController, bool>(
          selector: (inst, $) {
            return $(calculatorController.mathOperation).value == action;
          },
          builder: (_, __, isSelected, ___) {
            return Button.primary(
              label: label,
              isSelected: isSelected,
              onPressed: onPressed,
            );
          },
        ),
      );
    }

    if (action == ActionCalculator.point) {
      return Expanded(
        child: Button.tertiary(
          label: label,
          onPressed: onPressed,
        ),
      );
    }

    if (action == ActionCalculator.equal) {
      return Expanded(
        child: Button.primary(
          label: label,
          onPressed: onPressed,
        ),
      );
    }

    return Expanded(
      child: Button.secondary(
        label: label,
        onPressed: onPressed,
      ),
    );
  }
}
