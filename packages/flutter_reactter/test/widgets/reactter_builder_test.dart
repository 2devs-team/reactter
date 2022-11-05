import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../shareds/reactter_provider_builder.dart';
import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_context.dart';

void main() {
  group("ReactterBuilder", () {
    testWidgets("should re-render only its builder", (tester) async {
      late TestContext instanceObtained;
      int renderOutCount = 0;
      int renderInCount = 0;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (_, context, __) {
              context.watch<TestContext>((x) => []);
              renderOutCount += 1;

              return ReactterBuilder<TestContext>(
                listenHooks: (ctx) => [ctx.stateString],
                builder: (instance, context, child) {
                  instanceObtained = instance;
                  renderInCount += 1;
                  return Text(instance.stateString.value);
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      instanceObtained.stateString.value = "other value";

      await tester.pumpAndSettle();

      expect(renderOutCount, 1);
      expect(renderInCount, 2);
      expect(find.text("other value"), findsOneWidget);
    });

    testWidgets("should gets instance", (tester) async {
      late ReactterContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) => ReactterBuilder<TestContext>(
              builder: (instance, context, child) {
                instanceObtained = instance;
                return Text(instance.stateString.value);
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("initial"), findsOneWidget);

      expectLater(instanceObtained, isInstanceOf<TestContext>());
    });

    testWidgets("should gets instance with id", (tester) async {
      late final ReactterContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) => ReactterBuilder<TestContext>(
              id: 'uniqueId',
              builder: (instance, context, child) {
                instanceObtained = instance;
                return Text(instance.stateString.value);
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("from uniqueId"), findsOneWidget);

      expectLater(instanceObtained, isInstanceOf<TestContext>());
    });

    testWidgets("should listens hooks", (tester) async {
      late ReactterContext instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (instance, _, __) => ReactterBuilder<TestContext>(
              listenHooks: (instance) => [
                instance.stateString,
                instance.stateInt,
              ],
              builder: (instance, context, child) {
                instanceObtained = instance;

                return Column(
                  children: [
                    Text("stateString: ${instance.stateString.value}"),
                    Text("stateInt: ${instance.stateInt.value}"),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());

      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      (instanceObtained as TestContext).stateString.value = "new state";
      await tester.pumpAndSettle();

      expect(find.text("stateString: new state"), findsOneWidget);
      expect(find.text("stateInt: 0"), findsOneWidget);

      (instanceObtained as TestContext).stateInt.value = 99;
      await tester.pumpAndSettle();

      expect(find.text("stateString: new state"), findsOneWidget);
      expect(find.text("stateInt: 99"), findsOneWidget);
    });

    testWidgets("should shows child", (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (_, __, ___) => const ReactterBuilder<TestContext>(
              child: Text('child'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("child"), findsOneWidget);

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (_, __, ___) => ReactterBuilder<TestContext>(
              child: const Text('child2'),
              builder: (instance, context, child) {
                return Column(
                  children: [
                    Text(instance.stateString.value),
                    if (child != null) child,
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("child2"), findsOneWidget);
    });
  });
}
