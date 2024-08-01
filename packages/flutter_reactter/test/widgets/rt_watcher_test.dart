import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/test_builder.dart';

void main() {
  group("RtWatcher", () {
    testWidgets(
      "should rebuild when detected the state watched has changes",
      (tester) async {
        final signalString = UseState("initial");

        await tester.pumpWidget(
          TestBuilder(
            child: RtWatcher(
              (context, watch) => Text(watch(signalString).value),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text("initial"), findsOneWidget);

        signalString.value = "other value";

        await tester.pumpAndSettle();

        expect(find.text("other value"), findsOneWidget);
      },
    );

    testWidgets(
      "should rebuild when detected the state watched has changes using builder",
      (tester) async {
        final signalString = UseState("initial");

        await tester.pumpWidget(
          TestBuilder(
            child: RtWatcher.builder(
              child: const Text("child"),
              builder: (context, watch, child) {
                return Column(
                  children: [
                    Text(watch(signalString).value),
                    if (child != null) child,
                  ],
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text("initial"), findsOneWidget);
        expect(find.text("child"), findsOneWidget);

        signalString.value = "other value";

        await tester.pumpAndSettle();

        expect(find.text("other value"), findsOneWidget);
        expect(find.text("child"), findsOneWidget);
      },
    );
  });
}
