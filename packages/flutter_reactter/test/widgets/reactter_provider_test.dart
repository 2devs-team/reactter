import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../shareds/reactter_provider_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("ReactterProvider", () {
    testWidgets("should get instance from context", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (context, _, __) {
              instanceObtained = context.use<TestController>();

              return Text("stateString: ${instanceObtained.stateString.value}");
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: initial"), findsOneWidget);
    });

    testWidgets("should get the instance by id from context", (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            id: "uniqueId",
            builder: (context, _, __) {
              instanceObtained = context.use<TestController>("uniqueId");

              return Text("stateString: ${instanceObtained.stateString.value}");
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: from uniqueId"), findsOneWidget);
    });

    testWidgets(
        "should get the instance from context and watch hooks to builder re-render",
        (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            builder: (context, _, __) {
              instanceObtained = context.watch<TestController>(
                (inst) => [inst.stateString, inst.stateBool],
              );

              return Column(
                children: [
                  Text("stateString: ${instanceObtained.stateString.value}"),
                  Text("stateBool: ${instanceObtained.stateBool.value}"),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
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
        "should get the instance by id from context and watch hooks to builder re-render",
        (tester) async {
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviderBuilder(
            id: "uniqueId",
            builder: (context, _, __) {
              instanceObtained = context.watchId<TestController>(
                "uniqueId",
                (inst) => [inst.stateString, inst.stateBool],
              );

              return Column(
                children: [
                  Text("stateString: ${instanceObtained.stateString.value}"),
                  Text("stateBool: ${instanceObtained.stateBool.value}"),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: from uniqueId"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      await tester.pumpAndSettle();
      expect(find.text("stateBool: true"), findsOneWidget);
    });

    testWidgets("should shows child", (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: Column(
            children: [
              ReactterProvider(
                () => TestController(),
                child: const Text("child"),
              ),
              ReactterProvider(
                () => TestController(),
                child: const Text("child2"),
                builder: (_, context, child) {
                  if (child != null) return child;
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("child"), findsOneWidget);
      expect(find.text("child2"), findsOneWidget);
    });

    testWidgets(
        "should get the instance as lazy and watch hooks to builder re-render",
        (tester) async {
      bool isOnBuilder = false;
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvider.lazy(
            () => TestController(),
            builder: (context, child) {
              expect(
                Reactter.find<TestController>(),
                isOnBuilder ? instanceObtained : null,
              );

              isOnBuilder = true;
              instanceObtained = context.watch<TestController>();

              return Column(
                children: [
                  Text("stateString: ${instanceObtained.stateString.value}"),
                  Text("stateBool: ${instanceObtained.stateBool.value}"),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateBool: true"), findsOneWidget);
    });

    testWidgets(
        "should get the instance as lazy and watch hooks to builder re-render with id",
        (tester) async {
      bool isOnBuilder = false;
      late TestController instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvider.lazy(
            () => TestController(),
            id: "uniqueId",
            builder: (context, child) {
              expect(
                Reactter.find<TestController>("uniqueId"),
                isOnBuilder ? instanceObtained : null,
              );

              isOnBuilder = true;
              instanceObtained = context.watchId<TestController>(
                "uniqueId",
                (inst) => [inst.stateString, inst.stateBool],
              );

              return Column(
                children: [
                  Text("stateString: ${instanceObtained.stateString.value}"),
                  Text("stateBool: ${instanceObtained.stateBool.value}"),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(find.text("stateString: initial"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateString.value = "new value";
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateBool: false"), findsOneWidget);

      instanceObtained.stateBool.value = true;
      await tester.pumpAndSettle();
      expect(find.text("stateString: new value"), findsOneWidget);
      expect(find.text("stateBool: true"), findsOneWidget);
    });

    testWidgets("should get the instance as lazy and shows child",
        (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: Column(
            children: [
              ReactterProvider.lazy(
                () => TestController(),
                child: const Text("child"),
              ),
              ReactterProvider.lazy(
                () => TestController(),
                child: const Text("child2"),
                builder: (context, child) {
                  if (child != null) return child;

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("child"), findsOneWidget);
      expect(find.text("child2"), findsOneWidget);
    });

    testWidgets("should get the instance as lazy and shows child with id",
        (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: Column(
            children: [
              ReactterProvider.lazy(
                () => TestController(),
                id: "uniqueId",
                child: const Text("child"),
              ),
              ReactterProvider.lazy(
                () => TestController(),
                id: "uniqueId",
                child: const Text("child2"),
                builder: (context, child) {
                  if (child != null) return child;

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("child"), findsOneWidget);
      expect(find.text("child2"), findsOneWidget);
    });
  });
}
