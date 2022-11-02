import 'package:reactter/core.dart';
import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_context.dart';

void main() {
  group("ReactterContext", () {
    test("should throw the life-cycle events", () async {
      late TestContext? instance;
      late bool willUpdateChecked;
      late bool didUpdateChecked;
      late bool isDestroyed;

      Reactter.on(
        ReactterInstance<TestContext>(),
        Lifecycle.initialized,
        (TestContext? inst, __) {
          instance = inst;
        },
      );
      Reactter.on(
        ReactterInstance<TestContext>(),
        Lifecycle.willUpdate,
        (TestContext? inst, UseState hook) {
          willUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "initial");
        },
      );
      Reactter.on(
        ReactterInstance<TestContext>(),
        Lifecycle.didUpdate,
        (TestContext? inst, UseState hook) {
          didUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "changed");
        },
      );
      Reactter.on(
        ReactterInstance<TestContext>(),
        Lifecycle.destroyed,
        (_, __) {
          isDestroyed = true;
        },
      );

      final testContext = Reactter.create(builder: () => TestContext());
      testContext?.stateString.value = "changed";

      Reactter.delete<TestContext>();

      expectLater(instance, isA<TestContext>());
      expectLater(instance, testContext);
      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
      expectLater(isDestroyed, true);
    });

    test("should be created as nested way", () {
      final test2context = Reactter.create(builder: () => Test2Context())!;

      expectLater(test2context.testContext.instance, isA<TestContext>());

      Reactter.delete<Test2Context>();
    });
  });
}
