import 'package:examples/examples/2_calculator/controllers/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class CalculatorResult extends StatelessWidget {
  const CalculatorResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      height: 75,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: RtWatcher((context, watch) {
          final calculatorController = context.use<CalculatorController>();
          final result = watch(calculatorController.uResult).value;

          return Text(
            result,
            style: TextStyle(
              color: Colors.grey.shade100,
              fontSize: 48,
              fontWeight: FontWeight.w200,
            ),
          );
        }),
      ),
    );
  }
}
