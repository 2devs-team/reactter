import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/src/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/reactter_provider_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("ReactterStateListExtension's when method", () {
    testWidgets(
      "should watch dependencies changes and computed new state",
      (tester) async {
        late TestController instanceObtained;
        int nRendered = 0;

        await tester.pumpWidget(
          TestBuilder(
            child: ReactterProviderBuilder(
              builder: (_, context, __) {
                instanceObtained = context.use<TestController>();
                final stateA = instanceObtained.stateInt;
                final stateB = instanceObtained.stateDouble;

                final stateComputes = [stateA, stateB].when(
                  () => (stateA.value + stateB.value).clamp(5, 10).toInt(),
                );
                final stateComputed = stateComputes.first;

                context.watch<TestController>((inst) => stateComputes);
                nRendered += 1;
                return Text("stateComputed: ${stateComputed.value}");
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 5"), findsOneWidget);

        instanceObtained.stateInt.value += 5;
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 5"), findsOneWidget);

        instanceObtained.stateDouble.value += 1;
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 6"), findsOneWidget);

        instanceObtained.stateInt.value += 2;
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 8"), findsOneWidget);

        instanceObtained.stateDouble.value += 3;
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 10"), findsOneWidget);

        instanceObtained.stateInt.value -= 1;
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 10"), findsOneWidget);

        instanceObtained.stateDouble.value -= 2;
        await tester.pumpAndSettle();

        expect(find.text("stateComputed: 8"), findsOneWidget);
        expect(nRendered, 5);
      },
    );
  });
}
