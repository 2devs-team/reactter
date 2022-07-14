import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shareds/reactter_provider_builder.dart';
import 'shareds/test_context.dart';

void main() {
  group("ReactterScope", () {
    late final TestContext instanceObtained;
    testWidgets("should gets instance from context watch", (tester) async {
      await tester.pumpWidget(
        ReactterProviderBuilder(
          builder: (BuildContext context, Widget? child) {
            instanceObtained = context.use<TestContext>();

            return Column(
              children: [
                Text(
                  "ReactterProvider's builder state: ${instanceObtained.stateString.value}",
                ),
                ReactterScope(builder: (context, child) {
                  final testContext = context.watch<TestContext>();

                  return Text(
                    "ReactterScope's build state: ${testContext.stateString.value}",
                  );
                })
              ],
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      instanceObtained.stateString.value = "new value";

      await tester.pumpAndSettle();

      expect(
        find.text("ReactterProvider's builder state: initial"),
        findsOneWidget,
      );
      expect(
        find.text("ReactterScope's build state: new value"),
        findsOneWidget,
      );
    });
  });
}
