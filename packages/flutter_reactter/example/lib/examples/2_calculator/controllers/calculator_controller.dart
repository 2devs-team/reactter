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
  final uResult = UseState("0", debugLabel: "uResult");
  final uMathOperation = UseState<ActionCalculator?>(
    null,
    debugLabel: "uMathOperation",
  );

  ActionCalculator? _lastAction;
  double? _numberMemorized;

  void executeAction(ActionCalculator action, [int? value]) {
    switch (action) {
      case ActionCalculator.number:
        if (value != null) _insertNumber(value);
        break;
      case ActionCalculator.add:
      case ActionCalculator.subtract:
      case ActionCalculator.multiply:
      case ActionCalculator.divide:
        _resolveMathOperation(action);
        break;
      case ActionCalculator.equal:
        _equal();
        break;
      case ActionCalculator.sign:
        _changeSign();
        break;
      case ActionCalculator.porcentage:
        _calculatePercentage();
        break;
      case ActionCalculator.point:
        _addPoint();
        break;
      case ActionCalculator.clear:
        _clear();
        break;
    }

    _lastAction = action;
  }

  void _insertNumber(int value) {
    if (_lastAction
        case != ActionCalculator.number &&
            != ActionCalculator.point &&
            != ActionCalculator.sign) {
      _resetResult();
    }

    _concatValue(value);
  }

  void _resolveMathOperation(ActionCalculator action) {
    uMathOperation.value = action;
    _resolve();
    _numberMemorized = double.tryParse(uResult.value);
  }

  void _equal() {
    final resultNumber = double.tryParse(uResult.value);

    _resolve();

    if (_lastAction != ActionCalculator.equal) {
      _numberMemorized = resultNumber;
    }
  }

  void _changeSign() {
    final resultNumber = double.tryParse(uResult.value) ?? 0;
    uResult.value = _formatValue(resultNumber * -1);
  }

  void _calculatePercentage() {
    final resultNumber = double.tryParse(uResult.value) ?? 0;
    uResult.value = _formatValue(resultNumber / 100);
  }

  void _addPoint() {
    if (uResult.value.contains(".")) return;

    uResult.value = "${uResult.value}.";
  }

  void _clear() {
    uMathOperation.value = null;
    _numberMemorized = null;
    _resetResult();
  }

  void _resolve() {
    if (_numberMemorized == null) return;

    final resultNumber = double.tryParse(uResult.value) ?? 0;
    final mathOperationMethod = mathOperationMethods[uMathOperation.value];
    final resultOfOperation = mathOperationMethod?.call(
      _numberMemorized ?? resultNumber,
      resultNumber,
    );

    uResult.value = _formatValue(resultOfOperation ?? 0);
  }

  void _resetResult() {
    uResult.value = _formatValue(0.0);
  }

  void _concatValue(int? value) {
    final numConcatenated = double.tryParse("${uResult.value}$value") ?? 0;
    uResult.value = _formatValue(numConcatenated);
  }

  String _formatValue(double value) {
    return value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : "$value";
  }
}
