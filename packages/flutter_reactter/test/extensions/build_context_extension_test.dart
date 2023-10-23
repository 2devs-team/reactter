import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/src/extensions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/reactter_provider_builder.dart';
import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("ReactterBuildContextExtension", () {
    testWidgets(
      "should throw exception when instance not found",
      (tester) async {
        await tester.pumpWidget(
          TestBuilder(
            child: Builder(
              builder: (context) {
                context.use<TestController>();
                return const Text("Rendered");
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.takeException(),
          isInstanceOf<ReactterInstanceNotFoundException>(),
        );
        expect(find.text("Rendered"), findsNothing);
      },
    );

    testWidgets(
      "should get null when instance not found",
      (tester) async {
        late TestController? instanceObtained;

        await tester.pumpWidget(
          TestBuilder(
            child: Builder(
              builder: (context) {
                instanceObtained = context.use<TestController?>();

                return Text(
                  "stateString: ${instanceObtained?.stateString.value ?? 'not found'}",
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expectLater(instanceObtained, null);
        expect(find.text("stateString: not found"), findsOneWidget);
      },
    );

    testWidgets(
      "should watch instance changes",
      (tester) async {
        late TestController instanceObtained;

        await tester.pumpWidget(
          TestBuilder(
            child: ReactterProviderBuilder(
              builder: (_, context, __) {
                instanceObtained = context.watch<TestController>();

                return Text(
                  "stateString: ${instanceObtained.stateString.value}",
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expectLater(instanceObtained, isInstanceOf<TestController>());
        expect(find.text("stateString: initial"), findsOneWidget);

        instanceObtained.stateString.value = "new value";
        await tester.pumpAndSettle();

        expect(find.text("stateString: new value"), findsOneWidget);
      },
    );

    testWidgets(
      "should watch instance's states",
      (tester) async {
        late TestController instanceObtained;

        await tester.pumpWidget(
          TestBuilder(
            child: ReactterProviderBuilder(
              builder: (_, context, __) {
                instanceObtained = context.watch<TestController>(
                  (inst) => [inst.stateInt],
                );

                return Column(
                  children: [
                    Text("stateString: ${instanceObtained.stateString.value}"),
                    Text("stateInt: ${instanceObtained.stateInt.value}"),
                  ],
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expectLater(instanceObtained, isInstanceOf<TestController>());
        expect(find.text("stateString: initial"), findsOneWidget);
        expect(find.text("stateInt: 0"), findsOneWidget);

        instanceObtained.stateString.value = "new value";
        await tester.pumpAndSettle();

        expect(find.text("stateString: initial"), findsOneWidget);
        expect(find.text("stateInt: 0"), findsOneWidget);

        instanceObtained.stateInt.value += 2;
        await tester.pumpAndSettle();

        expect(find.text("stateString: new value"), findsOneWidget);
        expect(find.text("stateInt: 2"), findsOneWidget);
      },
    );

    testWidgets(
        "should watch multiple instance's states, using different context.watch",
        (tester) async {
      late TestController instanceObtained;
      late TestController instanceObtainedWithId;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              instanceObtained = context.use<TestController>();
              instanceObtainedWithId = context.use<TestController>('uniqueId');

              return Column(
                children: [
                  Builder(builder: (context) {
                    // any change of any states without id
                    context.watch<TestController>((inst) => [inst.stateString]);
                    context.watch<TestController>();

                    return Column(
                      children: [
                        Text(
                          "stateStringByIdDontWatch: ${instanceObtainedWithId.stateString.value}",
                        ),
                        Text(
                          "stateString: ${instanceObtained.stateString.value}",
                        ),
                      ],
                    );
                  }),
                  Builder(builder: (context) {
                    // only change of stateString with id
                    context.watchId<TestController>(
                      'uniqueId',
                      (inst) => [inst.stateString],
                    );

                    return Text(
                      "stateStringById: ${instanceObtainedWithId.stateString.value}",
                    );
                  }),
                  Builder(
                    builder: (context) {
                      // any change of stateInt
                      context.watch<TestController>((inst) => [inst.stateInt]);
                      context.watch<TestController>(
                        (inst) => [instanceObtainedWithId.stateInt],
                      );

                      return Column(
                        children: [
                          Text(
                            "stateIntById: ${instanceObtainedWithId.stateInt.value}",
                          ),
                          Text("stateInt: ${instanceObtained.stateInt.value}"),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expectLater(instanceObtainedWithId, isInstanceOf<TestController>());

      expect(
        find.text("stateStringByIdDontWatch: from uniqueId"),
        findsOneWidget,
      );
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateStringById: from uniqueId"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(
        find.text("stateStringByIdDontWatch: from uniqueId"),
        findsOneWidget,
      );
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: from uniqueId"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtainedWithId.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(
          find.text("stateStringByIdDontWatch: from uniqueId"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: new value"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateInt.value += 2;
      await tester.pumpAndSettle();

      expect(find.text("stateStringByIdDontWatch: new value"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: new value"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 2"), findsOneWidget);

      instanceObtainedWithId.stateInt.value += 5;
      await tester.pumpAndSettle();

      expect(find.text("stateStringByIdDontWatch: new value"), findsOneWidget);
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateStringById: new value"), findsOneWidget);
      expect(find.text("stateIntById: 5"), findsOneWidget);
      expect(find.text("stateInt: 2"), findsOneWidget);
    });
  });
}
