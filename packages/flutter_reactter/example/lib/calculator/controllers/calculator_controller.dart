import 'package:flutter_reactter/flutter_reactter.dart';

enum ActionCalculator {
  add,
  subtract,
  multiply,
  divide,
  equal,
  clear,
  sign,
  porcentage,
  point,
  number,
}

final mathOperationMethods = {
  ActionCalculator.add: (double first, double second) => first + second,
  ActionCalculator.subtract: (double first, double second) => first - second,
  ActionCalculator.multiply: (double first, double second) => first * second,
  ActionCalculator.divide: (double first, double second) => first / second,
};

class CalculatorController {
  final mathOperation = Signal<ActionCalculator?>(null);
  final result = "0".signal;

  ActionCalculator? _lastAction;
  double? _numberMemorized;

  late final _actionMethods = {
    ActionCalculator.number: _insertNumber,
    ActionCalculator.add: _resolveMathOperation,
    ActionCalculator.subtract: _resolveMathOperation,
    ActionCalculator.multiply: _resolveMathOperation,
    ActionCalculator.divide: _resolveMathOperation,
    ActionCalculator.equal: _equal,
    ActionCalculator.sign: _changeSign,
    ActionCalculator.porcentage: _calculatePercentage,
    ActionCalculator.point: _addPoint,
    ActionCalculator.clear: _clear,
  };

  void executeAction(ActionCalculator action, [int? value]) {
    final actionMethod = _actionMethods[action];

    if (actionMethod is Function(int) && value != null) {
      actionMethod(value);
    } else if (actionMethod is Function(ActionCalculator)) {
      actionMethod(action);
    } else {
      actionMethod?.call();
    }

    _lastAction = action;
  }

  void _insertNumber(int value) {
    if (_lastAction != ActionCalculator.number) _resetResult();
    _concatValue(value);
  }

  void _resolveMathOperation(ActionCalculator action) {
    mathOperation.value = action;
    _resolve();
    _numberMemorized = double.tryParse(result.value);
  }

  void _equal() {
    final resultNumber = double.tryParse(result.value);
    _resolve();
    if (_lastAction != ActionCalculator.equal) _numberMemorized = resultNumber;
  }

  void _changeSign() {
    result(_formatValue(double.parse(result.value) * -1));
  }

  void _calculatePercentage() {
    result(_formatValue(double.parse(result.value) / 100));
  }

  void _addPoint() {
    if (!result.value.contains(".")) result("$result.");
  }

  void _clear() {
    mathOperation.value = null;
    _numberMemorized = null;
    _resetResult();
  }

  void _resolve() {
    if (_numberMemorized == null) return;

    final resultNumber = double.parse(result.value);
    final mathOperationMethod = mathOperationMethods[mathOperation.value];
    final resultOfOperation = mathOperationMethod?.call(
      _numberMemorized ?? resultNumber,
      resultNumber,
    );

    result(_formatValue(resultOfOperation ?? 0));
  }

  void _resetResult() => result(_formatValue(0.0));

  void _concatValue(int? value) {
    result(_formatValue(double.tryParse("$result$value") ?? 0));
  }

  String _formatValue(double value) {
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : "$value";
  }
}
