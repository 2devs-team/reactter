import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'counter_controller.dart';

class CounterDivisible extends StatelessWidget {
  final String? id;
  final int byNum;

  const CounterDivisible({
    Key? key,
    required this.byNum,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Select the `count` state from the `CounterController`,
    // calculate if the `count` is divisible by num(`byNum`)
    // and rebuild the widget tree when the value(`isDivisibleByNum`) changes
    return RtSelector<CounterController, bool>(
      id: id,
      selector: (counterController, select) {
        return select(counterController.count).value % byNum == 0;
      },
      builder: (context, counterController, isDivisibleByNum, child) {
        print(
          "Rebuild selector(id: '$id', byNum: $byNum): $isDivisibleByNum",
        );

        return Text(
          isDivisibleByNum ? "Divisible by $byNum" : "Not divisible by $byNum",
        );
      },
    );
  }
}
