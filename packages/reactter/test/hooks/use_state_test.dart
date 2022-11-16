import 'package:test/test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';

void main() {
  group("UseState", () {
    test("should has a initial value", () {
      final testContext =
          Reactter.create<TestContext>(builder: () => TestContext())!;

      expect(testContext.stateBool.value, false);
      expect(testContext.stateString.value, "initial");
      expect(testContext.stateInt.value, 0);
      expect(testContext.stateDouble.value, 0.0);
      expect(testContext.stateList.value.isEmpty, true);
      expect(testContext.stateMap.value.isEmpty, true);
      expect(testContext.stateClass.value, null);

      Reactter.delete<TestContext>();
    });

    test("should changes state value", () {
      final testContext =
          Reactter.create<TestContext>(builder: () => TestContext())!;

      testContext.stateBool.value = !testContext.stateBool.value;
      testContext.stateString.value = "new value";
      testContext.stateInt.value += 2;
      testContext.stateDouble.value -= 2;
      testContext.stateList.value = [1, 2, 3];
      testContext.stateMap.value = {"x": 1, "y": 2, "z": 3};
      testContext.stateClass.value = TestClass("other class");

      expect(testContext.stateBool.value, true);
      expect(testContext.stateString.value, "new value");
      expect(testContext.stateInt.value, 2);
      expect(testContext.stateDouble.value, -2);
      expect(testContext.stateList.value.length, 3);
      expect(testContext.stateMap.value.length, 3);
      expect(testContext.stateClass.value?.prop, "other class");

      Reactter.delete<TestContext>();
    });

    test("should notifies when will update", () {
      final testContext =
          Reactter.create<TestContext>(builder: () => TestContext())!;

      testContext.stateInt.value = 1;

      late final int willUpdateValue;

      Reactter.one(
        testContext.stateInt,
        Lifecycle.willUpdate,
        (inst, param) {
          willUpdateValue = testContext.stateInt.value;
        },
      );

      testContext.stateInt.value += 1;

      expectLater(willUpdateValue, 1);

      Reactter.delete<TestContext>();
    });

    test("should notifies when did update", () async {
      final testContext =
          Reactter.create<TestContext>(builder: () => TestContext())!;

      testContext.stateInt.value = 1;

      int didUpdateValue = 0;

      Reactter.one(
        testContext.stateInt,
        Lifecycle.didUpdate,
        (inst, param) {
          didUpdateValue = testContext.stateInt.value;
        },
      );

      testContext.stateInt.value += 1;

      expectLater(didUpdateValue, 2);

      Reactter.one(
        testContext.stateInt,
        Lifecycle.didUpdate,
        (inst, param) {
          didUpdateValue = testContext.stateInt.value;
        },
      );

      testContext.update(
        () => testContext.stateInt.update(() {
          testContext.stateInt.value = 3;
        }),
      );

      await Future.microtask(() {});

      expectLater(testContext.stateInt.value, 3);

      Reactter.delete<TestContext>();
    });

    test("should be updated as async way", () async {
      final testContext =
          Reactter.create<TestContext>(builder: () => TestContext())!;

      testContext.stateInt.value = 1;

      late final int didUpdateValue;

      Reactter.one(
        testContext.stateInt,
        Lifecycle.didUpdate,
        (inst, param) {
          didUpdateValue = testContext.stateInt.value;
        },
      );

      await testContext.stateInt.updateAsync(() {
        return Future.microtask(() => testContext.stateInt.value += 1);
      });

      expectLater(didUpdateValue, 2);

      Reactter.delete<TestContext>();
    });
  });
}
