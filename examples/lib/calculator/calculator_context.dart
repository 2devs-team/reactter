// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_reactter/flutter_reactter.dart';

enum ActionCalculator {
  add,
  subtract,
  multiply,
  divide,
  clear,
  equal,
  sign,
  porcentage,
  point,
  number,
}

class CalculatorContext extends ReactterContext {
  late final operations = {
    ActionCalculator.add: (double first, double second) => first + second,
    ActionCalculator.subtract: (double first, double second) => first - second,
    ActionCalculator.multiply: (double first, double second) => first * second,
    ActionCalculator.divide: (double first, double second) => first / second,
  };

  double? first, second;
  ActionCalculator? lastAction;

  final operation = Signal<ActionCalculator?>(null);
  final result = "0".signal;

  void executeAction(ActionCalculator action, [int? value]) {
    if (action == ActionCalculator.clear) {
      first = null;
      second = null;
      operation(null);
      result("0");
      lastAction = action;
      return;
    }

    final isOperator = operations.keys.contains(action);
    final isOperatorLastAction = operations.keys.contains(lastAction);

    if (isOperator && !isOperatorLastAction) {
      first = double.tryParse(result());
      operation(action);
      lastAction = action;
      return;
    }

    if (action == ActionCalculator.equal) {
      if (first == null || operation == null) return;

      second = double.parse(result());

      final fnOperation = operations[operation()]!;

      result(formatValue(fnOperation(first!, second!)));
      lastAction = action;
      return;
    }

    if (action == ActionCalculator.porcentage) {
      result(formatValue(double.parse(result()) / 100));
      lastAction = action;
      return;
    }

    if (action == ActionCalculator.sign) {
      result(formatValue(double.parse(result()) * -1));
      lastAction = action;
      return;
    }

    if (action == ActionCalculator.point) {
      if (result().contains(".")) return;

      result("$result.");
      lastAction = action;
      return;
    }

    if (isOperatorLastAction || lastAction == ActionCalculator.equal) {
      result(formatValue((value ?? 0.0).toDouble()));
      lastAction = action;
      return;
    }

    result(formatValue(double.tryParse("$result$value") ?? 0));
    lastAction = action;
  }

  String formatValue(double value) {
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : "$value";
  }
}
