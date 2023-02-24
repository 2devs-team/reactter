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
                builder: (_, __) {
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
                  CalculatorButton.secondary(
                    value: "C",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.clear),
                  ),
                  CalculatorButton.secondary(
                    value: "+/–",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.sign),
                  ),
                  CalculatorButton.secondary(
                    value: "%",
                    onPressed: () => calculatorCtx
                        .executeAction(ActionCalculator.porcentage),
                  ),
                  ReactterWatcher(
                    builder: (_, __) {
                      return CalculatorButton.primary(
                        value: "÷",
                        isSelected: calculatorCtx.mathOperation ==
                            ActionCalculator.divide,
                        onPressed: () => calculatorCtx
                            .executeAction(ActionCalculator.divide),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CalculatorButton.tertiary(
                    value: "7",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 7),
                  ),
                  CalculatorButton.tertiary(
                    value: "8",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 8),
                  ),
                  CalculatorButton.tertiary(
                    value: "9",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 9),
                  ),
                  ReactterWatcher(
                    builder: (_, __) {
                      return CalculatorButton.primary(
                        value: "×",
                        isSelected: calculatorCtx.mathOperation ==
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
                  CalculatorButton.tertiary(
                    value: "4",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 4),
                  ),
                  CalculatorButton.tertiary(
                    value: "5",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 5),
                  ),
                  CalculatorButton.tertiary(
                    value: "6",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 6),
                  ),
                  ReactterWatcher(
                    builder: (_, __) {
                      return CalculatorButton.primary(
                        value: "–",
                        isSelected: calculatorCtx.mathOperation ==
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
                  CalculatorButton.tertiary(
                    value: "1",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 1),
                  ),
                  CalculatorButton.tertiary(
                    value: "2",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 2),
                  ),
                  CalculatorButton.tertiary(
                    value: "3",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 3),
                  ),
                  ReactterWatcher(
                    builder: (_, __) {
                      return CalculatorButton.primary(
                        value: "+",
                        isSelected:
                            calculatorCtx.mathOperation == ActionCalculator.add,
                        onPressed: () =>
                            calculatorCtx.executeAction(ActionCalculator.add),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  CalculatorButton.tertiary(
                    flex: 2,
                    value: "0",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.number, 0),
                  ),
                  CalculatorButton.tertiary(
                    value: ".",
                    onPressed: () =>
                        calculatorCtx.executeAction(ActionCalculator.point, 1),
                  ),
                  CalculatorButton.primary(
                    value: "=",
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
  final int flex;
  final Color? color;
  final bool isSmall, isSelected;
  final VoidCallback? onPressed;

  CalculatorButton.primary({
    Key? key,
    required this.value,
    this.isSelected = false,
    this.onPressed,
  })  : isSmall = true,
        flex = 1,
        color = Colors.amberAccent.shade700,
        super(key: key);

  CalculatorButton.secondary({
    Key? key,
    required this.value,
    this.isSelected = false,
    this.onPressed,
  })  : isSmall = true,
        flex = 1,
        color = Colors.grey.shade800,
        super(key: key);

  CalculatorButton.tertiary({
    Key? key,
    required this.value,
    this.flex = 1,
    this.onPressed,
  })  : isSmall = true,
        isSelected = false,
        color = Colors.grey.shade700,
        super(key: key);

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
            style: isSmall
                ? Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white)
                : Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
