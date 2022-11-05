import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../shareds/reactter_provider_builder.dart';
import '../../shareds/reactter_providers_builder.dart';
import '../../shareds/test_builder.dart';
import '../../shareds/test_context.dart';

void main() {
  group("ReactterBuildContextExtension", () {
    testWidgets(
        "should throw exception when ReactterContext's instance not found",
        (tester) async {
      bool hasException = false;

      await tester.pumpWidget(
        TestBuilder(
          child: Builder(
            builder: (context) {
              try {
                context.use<TestContext>();
                return const Text("Rendered");
              } catch (e) {
                hasException = true;
                return Text(e.toString());
              }
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(hasException, true);
      expect(find.text("Rendered"), findsNothing);
    });

    testWidgets("should gets null when ReactterContext's instance not found",
        (tester) async {
      late TestContext? instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: Builder(
            builder: (context) {
              instanceObtained = context.use<TestContext?>();

              return Text(
                  "stateString: ${instanceObtained?.stateString.value ?? 'not found'}");
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, null);
      expect(find.text("stateString: not found"), findsOneWidget);
    });

    testWidgets("should watch ReactterContext's instance", (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (_, context, __) {
              instanceObtained = context.watch<TestContext>();

              return Text("stateString: ${instanceObtained.stateString.value}");
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(find.text("stateString: initial"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(find.text("stateString: new value"), findsOneWidget);
    });

    testWidgets("should watch ReactterContext's hooks", (tester) async {
      late TestContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (_, context, __) {
              instanceObtained =
                  context.watch<TestContext>((ctx) => [ctx.stateInt]);

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

      expectLater(instanceObtained, isInstanceOf<TestContext>());
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
    });

    testWidgets(
        "should watch multiple ReactterContext's hooks, using different context.watch",
        (tester) async {
      late TestContext instanceObtained;
      late TestContext instanceObtainedWithId;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (context, _) {
              instanceObtained = context.use<TestContext>();
              instanceObtainedWithId = context.use<TestContext>('uniqueId');

              return Column(
                children: [
                  Builder(builder: (context) {
                    // any change of any hooks without id
                    context.watch<TestContext>((ctx) => [ctx.stateString]);
                    context.watch<TestContext>();

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
                    context.watchId<TestContext>(
                      'uniqueId',
                      (ctx) => [ctx.stateString],
                    );

                    return Text(
                      "stateStringById: ${instanceObtainedWithId.stateString.value}",
                    );
                  }),
                  Builder(
                    builder: (context) {
                      // any change of stateInt
                      context.watch<TestContext>((ctx) => [ctx.stateInt]);
                      context.watch<TestContext>(
                        (ctx) => [instanceObtainedWithId.stateInt],
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

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expectLater(instanceObtainedWithId, isInstanceOf<TestContext>());

      expect(
          find.text("stateStringByIdDontWatch: from uniqueId"), findsOneWidget);
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateStringById: from uniqueId"), findsOneWidget);
      expect(find.text("stateIntById: 0"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();

      expect(
          find.text("stateStringByIdDontWatch: from uniqueId"), findsOneWidget);
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
