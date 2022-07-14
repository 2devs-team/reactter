import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shareds/reactter_providers_builder.dart';
import 'shareds/test_context.dart';

void main() {
  group("ReactterProviders", () {
    testWidgets("should gets instance form different ReactterProvider",
        (tester) async {
      late TestContext instanceObtained;
      late TestContext instanceObtainedWithId;

      await tester.pumpWidget(
        ReactterProvidersBuilder(
          builder: (BuildContext context, Widget? child) {
            instanceObtained = context.use<TestContext>();
            instanceObtainedWithId = context.use<TestContext>("uniqueId");

            return Column(
              children: [
                Text("stateString: ${instanceObtained.stateString.value}"),
                Text(
                    "stateString: ${instanceObtainedWithId.stateString.value}"),
              ],
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expectLater(instanceObtained, isInstanceOf<TestContext>());
      expect(find.text("stateString: initial"), findsOneWidget);
      expectLater(instanceObtainedWithId, isInstanceOf<TestContext>());
      expect(find.text("stateString: from uniqueId"), findsOneWidget);
    });
  });
}
