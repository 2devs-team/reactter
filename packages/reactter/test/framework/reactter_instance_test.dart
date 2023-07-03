import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/src/framework.dart';
import 'package:reactter/src/hooks.dart';
import 'package:reactter/src/lifecycle.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("ReactterInstance", () {
    test("should throw the life-cycle events", () async {
      late TestController? instance;
      late bool willUpdateChecked;
      late bool didUpdateChecked;
      late bool isDestroyed;

      Reactter.on(
        ReactterInstance<TestController>(),
        Lifecycle.initialized,
        (TestController? inst, __) {
          instance = inst;
        },
      );
      Reactter.on(
        ReactterInstance<TestController>(),
        Lifecycle.willUpdate,
        (TestController? inst, UseState hook) {
          willUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "initial");
        },
      );
      Reactter.on(
        ReactterInstance<TestController>(),
        Lifecycle.didUpdate,
        (TestController? inst, UseState hook) {
          didUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "changed");
        },
      );
      Reactter.on(
        ReactterInstance<TestController>(),
        Lifecycle.destroyed,
        (_, __) {
          isDestroyed = true;
        },
      );

      final testController = Reactter.create(builder: () => TestController());
      testController?.stateString.value = "changed";

      Reactter.delete<TestController>();

      expectLater(instance, isA<TestController>());
      expectLater(instance, testController);
      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
      expectLater(isDestroyed, true);
    });

    test("should be created as nested way", () {
      final test3Controller =
          Reactter.create(builder: () => Test3Controller())!;
      late final test2Controller = test3Controller.test2Controller.instance;
      late final testController = test2Controller?.testController.instance;

      expectLater(testControllerExt.instance, isA<TestController>());
      expectLater(test2Controller, isA<Test2Controller>());
      expectLater(testController, isA<TestController>());

      Reactter.delete<Test2Controller>();
    });
  });
}
