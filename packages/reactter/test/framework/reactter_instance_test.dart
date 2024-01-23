import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/src/framework/framework.dart';
import 'package:reactter/src/hooks/hooks.dart';

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

      final testController = Reactter.create(() => TestController());
      testController?.stateString.value = "changed";

      Reactter.delete<TestController>();

      expectLater(instance, isA<TestController>());
      expectLater(instance, testController);
      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
      expectLater(isDestroyed, true);
    });

    test("should be created as nested way", () {
      expect(
        test3Controller.instance,
        isNull,
      );
      expect(
        test3Controller.instance?.test2Controller.instance,
        isNull,
      );
      expect(
        test3Controller
            .instance?.test2Controller.instance?.testController.instance,
        isNull,
      );

      Reactter.create(() => Test3Controller());

      expect(
        test3Controller.instance,
        isA<Test3Controller>(),
      );
      expect(
        test3Controller.instance?.test2Controller.instance,
        isA<Test2Controller>(),
      );
      expect(
        test3Controller
            .instance?.test2Controller.instance?.testController.instance,
        isA<TestController>(),
      );

      Reactter.delete<Test2Controller>();

      expect(
        test3Controller.instance,
        isA<Test3Controller>(),
      );
      expect(
        test3Controller.instance?.test2Controller.instance,
        isNull,
      );
      expect(
        test3Controller
            .instance?.test2Controller.instance?.testController.instance,
        isNull,
      );

      Reactter.delete<Test3Controller>();

      expect(
        test3Controller.instance,
        isNull,
      );
      expect(
        test3Controller.instance?.test2Controller.instance,
        isNull,
      );
      expect(
        test3Controller
            .instance?.test2Controller.instance?.testController.instance,
        isNull,
      );
    });
  });
}
