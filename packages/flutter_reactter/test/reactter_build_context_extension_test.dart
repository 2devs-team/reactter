import 'package:flutter/widgets.dart';
import 'package:flutter_reactter/flutter_reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shareds/test_builder.dart';
import 'shareds/test_context.dart';

void main() {
  group("ReactterBuildContextExtension", () {
    testWidgets("should gets null when the instance not found", (tester) async {
      late TestContext? instanceObtained;

      await tester.pumpWidget(
        TestBuilder(
          child: Builder(
            builder: (context) {
              instanceObtained = context.read<TestContext?>();

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
  });
}
