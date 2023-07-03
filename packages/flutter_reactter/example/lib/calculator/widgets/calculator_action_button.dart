import 'package:examples/calculator/widgets/button.dart';
import 'package:examples/calculator/controllers/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

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

    onPressed() => calculatorController.executeAction(action);

    if (isMathOperation) {
      checkIsSelected() => calculatorController.mathOperation.value == action;

      return Expanded(
        child: ReactterConsumer<CalculatorController>(
          listenStates: (inst) => [inst.mathOperation].when(checkIsSelected),
          builder: (_, __, ___) {
            return Button.primary(
              label: label,
              isSelected: checkIsSelected(),
              onPressed: onPressed,
            );
          },
        ),
      );
    }

    if (action == ActionCalculator.point) {
      return Expanded(
        flex: 2,
        child: Button.tertiary(
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
