// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'calculator_context.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<CalculatorContext>(
      () => CalculatorContext(),
      builder: (calculatorCtx, context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Calculator'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ReactterWatcher(
                builder: (context, child) {
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "${calculatorCtx.result}",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  CalculatorButton(
                    value: "C",
                    color: Colors.grey[800],
                    isSmall: true,
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.clear),
                  ),
                  CalculatorButton(
                    value: "+/-",
                    color: Colors.grey[800],
                    isSmall: true,
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.sign),
                  ),
                  CalculatorButton(
                    value: "%",
                    color: Colors.grey[800],
                    onPressed: () => calculatorCtx
                        .executeAction(ActionCalculator.porcentage),
                  ),
                  ReactterWatcher(
                    builder: (context, _) {
                      return CalculatorButton(
                        value: "÷",
                        color: Colors.amberAccent.shade700,
                        isSelected:
                            calculatorCtx.operation == ActionCalculator.divide,
                        onPressed: () => calculatorCtx
                            .executeAction(ActionCalculator.divide),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CalculatorButton(
                    value: "7",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 7),
                  ),
                  CalculatorButton(
                    value: "8",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 8),
                  ),
                  CalculatorButton(
                    value: "9",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 9),
                  ),
                  ReactterWatcher(
                    builder: (context, _) {
                      return CalculatorButton(
                        value: "x",
                        color: Colors.amberAccent.shade700,
                        isSelected: calculatorCtx.operation ==
                            ActionCalculator.multiply,
                        onPressed: () => calculatorCtx
                            .executeAction(ActionCalculator.multiply),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CalculatorButton(
                    value: "4",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 4),
                  ),
                  CalculatorButton(
                    value: "5",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 5),
                  ),
                  CalculatorButton(
                    value: "6",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 6),
                  ),
                  ReactterWatcher(
                    builder: (context, _) {
                      return CalculatorButton(
                        value: "-",
                        color: Colors.amberAccent.shade700,
                        isSelected: calculatorCtx.operation ==
                            ActionCalculator.subtract,
                        onPressed: () => calculatorCtx
                            .executeAction(ActionCalculator.subtract),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CalculatorButton(
                    value: "1",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 1),
                  ),
                  CalculatorButton(
                    value: "2",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 2),
                  ),
                  CalculatorButton(
                    value: "3",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 3),
                  ),
                  ReactterWatcher(
                    builder: (context, _) {
                      return CalculatorButton(
                        value: "+",
                        color: Colors.amberAccent.shade700,
                        isSelected:
                            calculatorCtx.operation == ActionCalculator.add,
                        onPressed: () =>
                            calculatorCtx.executeAction(ActionCalculator.add),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CalculatorButton(
                    value: "0",
                    flex: 2,
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 0),
                  ),
                  CalculatorButton(
                    value: ".",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.point, 1),
                  ),
                  CalculatorButton(
                    value: "=",
                    color: Colors.amberAccent.shade700,
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.equal),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String value;
  final Color? color;
  final int flex;
  final bool isSmall, isSelected;
  final VoidCallback? onPressed;

  const CalculatorButton({
    Key? key,
    required this.value,
    this.color,
    this.flex = 1,
    this.isSelected = false,
    this.isSmall = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            primary: color ?? Colors.grey.shade700,
            side: BorderSide(width: isSelected ? 2 : 1),
            shape: const ContinuousRectangleBorder(side: BorderSide.none),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmall ? 18 : 24,
            ),
          ),
        ),
      ),
    );
  }
}
