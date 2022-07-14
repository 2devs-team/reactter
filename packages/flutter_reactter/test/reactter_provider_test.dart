import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'shareds/reactter_provider_builder.dart';
import 'shareds/test_context.dart';

void main() {
  group("ReactterProvider", () {
    testWidgets("should gets instance from context", (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        ReactterProviderBuilder(
          builder: (BuildContext context, Widget? child) {
            instanceObtained = context.use<TestContext>();

            return Text("stateString: ${instanceObtained.stateString.value}");
          },
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(find.text("stateString: initial"), findsOneWidget);
    });

    testWidgets("should gets the instance by id from context", (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        ReactterProviderBuilder(
          id: "uniqueId",
          builder: (BuildContext context, Widget? child) {
            instanceObtained = context.use<TestContext>("uniqueId");

            return Text("stateString: ${instanceObtained.stateString.value}");
          },
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(find.text("stateString: from uniqueId"), findsOneWidget);
    });

    testWidgets(
        "should gets the instance from context and watch hooks to builder re-render",
        (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        ReactterProviderBuilder(
          builder: (BuildContext context, Widget? child) {
            instanceObtained = context
                .watch<TestContext>((ctx) => [ctx.stateString, ctx.stateBool]);

            return Column(
              children: [
                Text("stateString: ${instanceObtained.stateString.value}"),
                Text("stateBool: ${instanceObtained.stateBool.value}"),
              ],
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      await tester.pumpAndSettle();
      expect(find.text("stateBool: true"), findsOneWidget);
    });

    testWidgets(
        "should gets the instance by id from context and watch hooks to builder re-render",
        (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        ReactterProviderBuilder(
          id: "uniqueId",
          builder: (BuildContext context, Widget? child) {
            instanceObtained = context.watchId<TestContext>(
              "uniqueId",
              (ctx) => [ctx.stateString, ctx.stateBool],
            );

            return Column(
              children: [
                Text("stateString: ${instanceObtained.stateString.value}"),
                Text("stateBool: ${instanceObtained.stateBool.value}"),
              ],
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(find.text("stateString: from uniqueId"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      await tester.pumpAndSettle();
      expect(find.text("stateBool: true"), findsOneWidget);
    });
  });
}
