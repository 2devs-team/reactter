import 'package:flutter/material.dart';
import 'package:flutter_reactter/src/extensions.dart';
import 'package:flutter_reactter/src/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/reactter_providers_builder.dart';
import '../shareds/test_builder.dart';
import '../shareds/test_controller.dart';

void main() {
  group("ReactterProviders", () {
    testWidgets("should gets instance form different ReactterProvider",
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
          tester.element(find.bySubtype<ReactterProvider>().first)
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
