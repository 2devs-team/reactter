import 'package:flutter/material.dart';
import 'package:flutter_reactter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_context.dart';

void main() {
  group("ReactterProviders", () {
    testWidgets("should gets instance form different ReactterProvider",
        (tester) async {
      late TestContext instanceObtained;
      late TestContext instanceObtainedWithId;
      const key = Key('uniqueKey');
      const key2 = Key('uniqueKey2');

      await tester.pumpWidget(
        TestBuilder(
          child: ReactterProvidersBuilder(
            key: key,
            builder: (BuildContext context, Widget? child) {
              instanceObtained = context.use<TestContext>();
              instanceObtainedWithId = context.use<TestContext>("uniqueId");

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
                      context.watch<TestContext>();

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
      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(
        find.text("Provider stateString: initial"),
        findsOneWidget,
      );

      expectLater(instanceObtainedWithId, isInstanceOf<TestContext>());
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

      tester.element(find.bySubtype<ReactterProvider>().first)
        ..deactivate()
        ..activate();

      final reactterProviderInheritedElement = tester.element(
        find
            .descendant(
              of: find.bySubtype<ReactterProvider>(),
              matching: find.bySubtype<ReactterProviderInherited>(),
            )
            .first,
      );

      final diagnostic = reactterProviderInheritedElement
          .toDiagnosticsNode()
          .toTimelineArguments();
      expect(diagnostic['id'], "null");
      expect(diagnostic['isRoot'], "true");
    });
  });
}
