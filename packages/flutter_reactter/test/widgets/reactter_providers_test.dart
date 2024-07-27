import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("ReactterProviders", () {
    testWidgets("should get dependency form different RtProvider",
        (tester) async {
      late TestController instanceObtained;
      late TestController instanceObtainedWithId;
      const key = Key('uniqueKey');
      const key2 = Key('uniqueKey2');

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            key: key,
            builder: (BuildContext context, Widget? child) {
              instanceObtained = context.use<TestController>();
              instanceObtainedWithId = context.use<TestController>("uniqueId");

              return Column(
                children: [
                  if (child != null) child,
                  Text(
                      "Provider stateString: ${instanceObtained.stateString.value}"),
                  Text(
                    "ProviderWithId stateString: ${instanceObtainedWithId.stateString.value}",
                  ),
                  ReactterProvidersBuilder(
                    key: key2,
                    builder: (context, child) {
                      context.watch<TestController>();

                      return Text(
                        "Provider2 stateString: ${instanceObtained.stateString.value}",
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

      // ignore: invalid_use_of_protected_member
      tester.state(find.byKey(key)).setState(() {});
      await tester.pumpAndSettle();

      expect(find.text("child"), findsOneWidget);
      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(
        find.text("Provider stateString: initial"),
        findsOneWidget,
      );

      expectLater(instanceObtainedWithId, isInstanceOf<TestController>());
      expect(
        find.text("ProviderWithId stateString: from uniqueId"),
        findsOneWidget,
      );

      instanceObtained.stateString.value = "changed";
      await tester.pumpAndSettle();

      // ignore: invalid_use_of_protected_member
      tester.state(find.byKey(key2)).setState(() {});
      await tester.pumpAndSettle();

      expect(find.text("Provider stateString: initial"), findsOneWidget);
      expect(find.text("Provider2 stateString: changed"), findsOneWidget);

      final reactterProviderInheritedElement =
          tester.element(find.bySubtype<RtProvider>().first)
            ..deactivate()
            ..activate();

      final diagnostic = reactterProviderInheritedElement
          .toDiagnosticsNode()
          .toTimelineArguments();

      expect(diagnostic?['id'], "null");
      expect(diagnostic?['isRoot'], "true");
    });

    testWidgets("should get dependency from RtProvider siblings",
        (tester) async {
      late TestController instanceObtained;
      late TestController instanceObtainedWithId;

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProviders(
            [
              RtProvider(
                () => TestController(),
              ),
              RtProvider(
                () {
                  final instFromProviderSibling = Rt.find<TestController>();

                  expect(instFromProviderSibling, isNotNull);

                  final inst = TestController();
                  inst.stateString.value = "from uniqueId";
                  return inst;
                },
                id: 'uniqueId',
              ),
            ],
            builder: (BuildContext context, Widget? child) {
              instanceObtained = context.watch<TestController>();
              instanceObtainedWithId = context.use<TestController>("uniqueId");

              return Column(
                children: [
                  if (child != null) child,
                  Text(
                    "Provider stateString: ${instanceObtained.stateString.value}",
                  ),
                  Text(
                    "ProviderWithId stateString: ${instanceObtainedWithId.stateString.value}",
                  ),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestController>());
      expect(
        find.text("Provider stateString: initial"),
        findsOneWidget,
      );
      expect(
        find.text("ProviderWithId stateString: from uniqueId"),
        findsOneWidget,
      );

      instanceObtained.stateString.value = "changed";
      await tester.pumpAndSettle();

      expect(find.text("Provider stateString: changed"), findsOneWidget);
      expect(
        find.text("ProviderWithId stateString: from uniqueId"),
        findsOneWidget,
      );

      final reactterProviderInheritedElement =
          tester.element(find.bySubtype<RtProvider>().first)
            ..deactivate()
            ..activate();

      final diagnostic = reactterProviderInheritedElement
          .toDiagnosticsNode()
          .toTimelineArguments();

      expect(diagnostic?['id'], "null");
      expect(diagnostic?['isRoot'], "true");
    });

    testWidgets("should use child widget", (tester) async {
      await tester.pumpWidget(
        TestBuilder(
          child: Column(
            children: [
              ReactterProviders(
                [
                  RtProvider.init(() => TestController()),
                ],
                child: Builder(
                  builder: (context) {
                    final testController = context.use<TestController>();

                    expect(
                      testController,
                      isInstanceOf<TestController>(),
                    );
                    return const Text("child");
                  },
                ),
                builder: (BuildContext context, Widget? child) {
                  return Column(
                    children: [
                      if (child != null) child,
                      Text(
                          "Provider stateString: ${context.use<TestController>().stateString.value}"),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("child"), findsOneWidget);
      expect(find.text("Provider stateString: initial"), findsOneWidget);

      final reactterProviderInheritedElement =
          tester.element(find.bySubtype<RtProvider>().first)
            ..deactivate()
            ..activate();

      final diagnostic = reactterProviderInheritedElement
          .toDiagnosticsNode()
          .toTimelineArguments();

      expect(diagnostic?['id'], "null");
      expect(diagnostic?['isRoot'], "true");
    });
  });
}
