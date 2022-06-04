import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';
import '../shareds/use_async_state_builder.dart';

void main() {
  group("UseAsyncState", () {
    test("should resolved state", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      expect(stateAsync.value, "initial");

      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");
    });

    test("should catch error", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      await stateAsync.resolve(true);

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.error);
      expect(stateAsync.error.toString(), "Exception: has a error");
    });

    test("should reset state", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");

      stateAsync.reset();

      expect(stateAsync.value, "initial");
    });

    testWidgets("should get the widget such state", (tester) async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      await tester.pumpWidget(UseAsyncStateBuilder(state: stateAsync));
      await tester.pumpAndSettle();

      expect(find.text("initial"), findsOneWidget);

      stateAsync.resolve();

      await tester.pumpWidget(UseAsyncStateBuilder(state: stateAsync));
      await tester.pumpAndSettle();

      expect(find.text("loading"), findsOneWidget);

      await tester.pumpWidget(UseAsyncStateBuilder(state: stateAsync));
      await tester.pumpAndSettle();

      expect(find.text("resolved"), findsOneWidget);

      await stateAsync.resolve(true);

      await tester.pumpWidget(UseAsyncStateBuilder(state: stateAsync));
      await tester.pumpAndSettle();

      expect(find.text("Exception: has a error"), findsOneWidget);
    });
  });
}
