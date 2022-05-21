import 'package:flutter_test/flutter_test.dart';

import '../shareds/test_context.dart';

class MyClass {
  final String prop;

  MyClass(this.prop);
}

void main() {
  group("UseState", () {
    test("should has a initial value", () {
      final testContext = TestContext();

      expect(testContext.stateBool.value, false);
      expect(testContext.stateString.value, "initial");
      expect(testContext.stateInt.value, 0);
      expect(testContext.stateDouble.value, 0.0);
      expect(testContext.stateList.value.isEmpty, true);
      expect(testContext.stateMap.value.isEmpty, true);
      expect(testContext.stateClass.value, null);
    });

    test("should change state value", () {
      final testContext = TestContext();

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
    });

    test("should notify when will update", () {
      final testContext = TestContext();

      testContext.stateInt.value = 1;

      late final int willUpdateValue;

      testContext.stateInt.onWillUpdate(() {
        willUpdateValue = testContext.stateInt.value;
      });

      testContext.stateInt.value += 1;

      expectLater(willUpdateValue, 1);
    });

    test("should notify when did update", () {
      final testContext = TestContext();

      testContext.stateInt.value = 1;

      late final int didUpdateValue;

      testContext.stateInt.onDidUpdate(() {
        didUpdateValue = testContext.stateInt.value;
      });

      testContext.stateInt.value += 1;

      expectLater(didUpdateValue, 2);
    });
  });
}
