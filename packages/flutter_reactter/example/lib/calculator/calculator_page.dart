import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'controllers/calculator_controller.dart';
import 'widgets/calculator_action_button.dart';
import 'widgets/calculator_number_button.dart';
import 'widgets/calculator_result.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<CalculatorController>(
      () => CalculatorController(),
      builder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Calculator'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CalculatorResult(),
              Row(
                children: [
                  CalculatorActionButton(action: ActionCalculator.clear),
                  CalculatorActionButton(action: ActionCalculator.sign),
                  CalculatorActionButton(action: ActionCalculator.porcentage),
                  CalculatorActionButton(action: ActionCalculator.divide),
                ],
              ),
              Row(
                children: [
                  CalculatorNumberButton(number: 7),
                  CalculatorNumberButton(number: 8),
                  CalculatorNumberButton(number: 9),
                  CalculatorActionButton(action: ActionCalculator.multiply),
                ],
              ),
              Row(
                children: [
                  CalculatorNumberButton(number: 4),
                  CalculatorNumberButton(number: 5),
                  CalculatorNumberButton(number: 6),
                  CalculatorActionButton(action: ActionCalculator.subtract),
                ],
              ),
              Row(
                children: [
                  CalculatorNumberButton(number: 1),
                  CalculatorNumberButton(number: 2),
                  CalculatorNumberButton(number: 3),
                  CalculatorActionButton(action: ActionCalculator.add),
                ],
              ),
              Row(
                children: [
                  CalculatorNumberButton(number: 0),
                  CalculatorActionButton(action: ActionCalculator.point),
                  CalculatorActionButton(action: ActionCalculator.equal),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
