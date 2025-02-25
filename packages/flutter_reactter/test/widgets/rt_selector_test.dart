import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';
import '../shareds/test_builder.dart';

void main() {
  group("RtSelector", () {
    testWidgets(
      "should rebuild when detected value has changes",
      (tester) async {
        final signalList = Signal(<int>[]);

        await tester.pumpWidget(
          RtScope(
            child: TestBuilder(
              child: RtSelector(
                selector: (_, $) {
                  return $(signalList)
                      .value
                      .fold<int>(0, (prev, elem) => prev + elem);
                },
                builder: (context, inst, total, child) => Text("total: $total"),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text("total: 0"), findsOneWidget);

        signalList.update((value) => value.addAll([1, 1, 2]));
        await tester.pumpAndSettle();

        expect(find.text("total: 4"), findsOneWidget);

        signalList.value[1] = 2;
        await tester.pumpAndSettle();

        expect(find.text("total: 4"), findsOneWidget);

        signalList.notify();
        await tester.pumpAndSettle();

        expect(find.text("total: 5"), findsOneWidget);
      },
    );
  });
}
