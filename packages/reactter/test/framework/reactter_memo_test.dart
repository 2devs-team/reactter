import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("ReactterMemo", () {
    test("should be a class callable with arguments", () {
      final testController = TestController();

      expect(testController.memo.call, isA<Function(Args)>());
    });

    test("should memoized the returned value by the calculate function", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));
      final value0Cached = testController.memo(null);
      final value1Cached = testController.memo(Args1(1));
      final value2Cached = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, true);
      expect(value1 == value1Cached, true);
      expect(value2 == value2Cached, true);
    });

    test("should overrided the cached value", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));
      final value0Cached = testController.memo(null, overrideCache: true);
      final value1Cached = testController.memo(Args1(1), overrideCache: true);
      final value2Cached = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, false);
      expect(value1 == value1Cached, false);
      expect(value2 == value2Cached, true);
    });

    test("should removed all cached data", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));

      testController.memo.clear();

      final newValue0 = testController.memo(null);
      final newValue1 = testController.memo(Args1(1));
      final newValue2 = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == newValue0, false);
      expect(value1 == newValue1, false);
      expect(value2 == newValue2, false);
    });

    test("should removed the cached data", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));

      testController.memo.remove(null);
      testController.memo.remove(Args1(1));

      final newValue0 = testController.memo(null);
      final newValue1 = testController.memo(Args1(1));
      final newValue2 = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == newValue0, false);
      expect(value1 == newValue1, false);
      expect(value2 == newValue2, true);
    });
  });

  group("Reactter.memo", () {
    test("should be a class callable with arguments", () {
      final testController = TestController();

      expect(testController.simpleMemo.call, isA<Function(Args)>());
    });

    test("should memoized the returned value by the calculate function", () {
      final testController = TestController();

      final value0 = testController.simpleMemo(null);
      final value1 = testController.simpleMemo(Args1(1));
      final value2 = testController.simpleMemo(Args2(1, 2));
      final value0Cached = testController.simpleMemo(null);
      final value1Cached = testController.simpleMemo(Args1(1));
      final value2Cached = testController.simpleMemo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, true);
      expect(value1 == value1Cached, true);
      expect(value2 == value2Cached, true);
    });

    test("should overrided the cached value", () {
      final testController = TestController();

      final value0 = testController.simpleMemo(null);
      final value1 = testController.simpleMemo(Args1(1));
      final value2 = testController.simpleMemo(Args2(1, 2));
      final value0Cached = testController.simpleMemo(null, overrideCache: true);
      final value1Cached =
          testController.simpleMemo(Args1(1), overrideCache: true);
      final value2Cached = testController.simpleMemo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, false);
      expect(value1 == value1Cached, false);
      expect(value2 == value2Cached, true);
    });
  });
}