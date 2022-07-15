import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_context.dart';

void main() {
  group("ReactterBuilder", () {
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
          child: ReactterProvidersBuilder(
            builder: (_, __) => ReactterBuilder<TestContext>(
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
          child: ReactterProvidersBuilder(
            builder: (_, __) => const ReactterBuilder<TestContext>(
              child: Text('child'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("child"), findsOneWidget);

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            builder: (_, __) => ReactterBuilder<TestContext>(
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
