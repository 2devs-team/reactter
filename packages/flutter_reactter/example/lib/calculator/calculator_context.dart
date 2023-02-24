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

final mathOperationActions = {
  ActionCalculator.add: (double first, double second) => first + second,
  ActionCalculator.subtract: (double first, double second) => first - second,
  ActionCalculator.multiply: (double first, double second) => first * second,
  ActionCalculator.divide: (double first, double second) => first / second,
};

class CalculatorContext extends ReactterContext {
  double? first, second;
  ActionCalculator? lastAction;

  final mathOperation = Signal<ActionCalculator?>(null);
  final result = "0".signal;

  void executeAction(ActionCalculator action, [int? value]) {
    final isMathOperator = mathOperationActions.keys.contains(action);
    final isMathOperatorLastAction =
        mathOperationActions.keys.contains(lastAction);
    final isEqualLastAction = lastAction == ActionCalculator.equal;

    lastAction = action;

    if (isMathOperator && !isMathOperatorLastAction) {
      return _saveNumberAndOperation(action);
    }

    if (action == ActionCalculator.porcentage) {
      return _calculatePercentage();
    }

    if (action == ActionCalculator.sign) {
      return _changeSign();
    }

    if (action == ActionCalculator.point) {
      return _addPoint();
    }

    if (action == ActionCalculator.equal) {
      return _resolve();
    }

    if (action == ActionCalculator.clear) {
      return _clear();
    }

    if (isMathOperatorLastAction || isEqualLastAction) {
      _resetResult();
    }

    result(_formatValue(double.tryParse("$result$value") ?? 0));
  }

  void _saveNumberAndOperation(ActionCalculator action) {
    first = double.tryParse(result.value);
    mathOperation(action);
  }

  void _calculatePercentage() {
    result(_formatValue(double.parse(result.value) / 100));
  }

  void _changeSign() {
    result(_formatValue(double.parse(result.value) * -1));
  }

  void _addPoint() {
    if (result.value.contains(".")) return;
    result("$result.");
  }

  void _resolve() {
    if (first == null || mathOperation == null) return;

    second = double.parse(result.value);

    final mathOperationAction = mathOperationActions[mathOperation.value];
    final resultOfOperation = mathOperationAction?.call(first!, second!);

    result(_formatValue(resultOfOperation ?? 0));
  }

  void _clear() {
    first = null;
    second = null;
    mathOperation.value = null;
    _resetResult();
  }

  void _resetResult() => result(_formatValue(0.0));

  String _formatValue(double value) {
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : "$value";
  }
}
