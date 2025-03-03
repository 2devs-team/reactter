import 'package:reactter/reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("UseState", () {
    test("should have a initial value", () {
      final testController = Rt.create<TestController>(() => TestController())!;

      expect(testController.stateBool.value, false);
      expect(testController.stateString.value, "initial");
      expect(testController.stateInt.value, 0);
      expect(testController.stateDouble.value, 0.0);
      expect(testController.stateList.value.isEmpty, true);
      expect(testController.stateMap.value.isEmpty, true);
      expect(testController.stateClass.value, null);

      Rt.delete<TestController>();
    });

    test("should change state value", () {
      final testController = Rt.create<TestController>(() => TestController())!;

      testController.stateBool.value = !testController.stateBool.value;
      testController.stateString.value = "new value";
      testController.stateInt.value += 2;
      testController.stateDouble.value -= 2;
      testController.stateList.value = [1, 2, 3];
      testController.stateMap.value = {"x": 1, "y": 2, "z": 3};
      testController.stateClass.value = TestClass("other class");

      expect(testController.stateBool.value, true);
      expect(testController.stateString.value, "new value");
      expect(testController.stateInt.value, 2);
      expect(testController.stateDouble.value, -2);
      expect(testController.stateList.value.length, 3);
      expect(testController.stateMap.value.length, 3);
      expect(testController.stateClass.value?.prop, "other class");

      Rt.delete<TestController>();
    });

    test("should notify when will update", () {
      final testController = Rt.create<TestController>(() => TestController())!;

      testController.stateInt.value = 1;

      late final int willUpdateValue;

      Rt.one(
        testController.stateInt,
        Lifecycle.willUpdate,
        (inst, param) {
          willUpdateValue = testController.stateInt.value;
        },
      );

      testController.stateInt.value += 1;

      expectLater(willUpdateValue, 1);

      Rt.delete<TestController>();
    });

    test("should notify when did update", () async {
      final testController = Rt.create<TestController>(() => TestController())!;

      testController.stateInt.value = 1;

      int didUpdateValue = 0;

      Rt.one(
        testController.stateInt,
        Lifecycle.didUpdate,
        (inst, param) {
          didUpdateValue = testController.stateInt.value;
        },
      );

      testController.stateInt.value += 1;

      expectLater(didUpdateValue, 2);

      Rt.one(
        testController.stateInt,
        Lifecycle.didUpdate,
        (inst, param) {
          didUpdateValue = testController.stateInt.value;
        },
      );

      testController.stateInt.update(() {
        testController.stateInt.value = 3;
      });

      expectLater(testController.stateInt.value, 3);

      Rt.delete<TestController>();
    });

    test("should update manually", () {
      final testController = Rt.create<TestController>(() => TestController())!;
      late bool didUpdate;

      testController.stateInt.value = 1;

      Rt.one(testController.stateInt, Lifecycle.didUpdate, (_, __) {
        expect(testController.stateInt.value, 1);
        didUpdate = true;
      });

      testController.stateInt.update();

      expectLater(didUpdate, true);

      Rt.delete<TestController>();
    });

    test("should update manually with callback", () {
      final testController = Rt.create<TestController>(() => TestController())!;

      testController.stateInt.value = 1;

      testController.stateInt.update(() {
        testController.stateInt.value += 1;
      });

      expect(testController.stateInt.value, 2);

      Rt.delete<TestController>();
    });

    test("should get debug label", () {
      final testController = Rt.create<TestController>(() => TestController())!;

      expect(testController.stateInt.debugLabel, 'stateInt');

      Rt.delete<TestController>();
    });

    test("should get debug info", () {
      final testController = Rt.create<TestController>(() => TestController())!;

      expect(
        testController.stateInt.debugInfo,
        {'value': 0},
      );

      testController.stateInt.value = 1;

      expect(
        testController.stateInt.debugInfo,
        {'value': 1},
      );

      Rt.delete<TestController>();
    });
  });
}
