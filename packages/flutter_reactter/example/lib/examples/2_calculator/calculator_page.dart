// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/2_calculator/controllers/calculator_controller.dart';
import 'package:examples/examples/2_calculator/widgets/calculator_action_button.dart';
import 'package:examples/examples/2_calculator/widgets/calculator_number_button.dart';
import 'package:examples/examples/2_calculator/widgets/calculator_result.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider(
      CalculatorController.new,
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
