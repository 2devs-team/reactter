import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';

class MyClass {
  final String prop;

  MyClass(this.prop);
}

void main() {
  group("UseEffect", () {
    test("callback should be called when its dependencies has changed", () {
      final testContext = TestContext();
      final stateA = testContext.stateBool;
      final stateB = testContext.stateInt;

      int nCalls = 0;

      UseEffect(() {
        nCalls += 1;

        expect(stateA.value, nCalls < 1 ? false : true);
        expect(stateB.value, nCalls < 2 ? 0 : 1);
      }, [stateA, stateB]);

      stateA.value = !stateA.value;
      stateB.value += 1;

      expect(nCalls, 2);
    });

    test("return callback should be called", () {
      final testContext = TestContext();
      final stateA = testContext.stateBool;
      final stateB = testContext.stateInt;
      final stateC = testContext.stateString;

      int nCalls = 0;

      UseEffect(() {
        return () {
          nCalls += 1;

          expect(stateA.value, nCalls < 1 ? false : true);
          expect(stateB.value, nCalls < 2 ? 0 : 1);
          expect(stateC.value, nCalls < 3 ? "initial" : "new value");
        };
      }, [stateA, stateB, stateC]);

      stateA.value = !stateA.value;
      stateB.value += 1;
      stateC.value += "new value";

      expect(nCalls, 2);
    });

    test("callback should be called with dispatchEffect", () {
      late final bool isCalled;

      UseEffect(() {
        isCalled = true;
      }, [], UseEffect.dispatchEffect);

      expectLater(isCalled, true);
    });

    test("return callback should be called with dispatchEffect", () {
      final testContext = TestContext();
      final stateA = testContext.stateBool;
      final stateB = testContext.stateInt;
      final stateC = testContext.stateString;

      int nCalls = 0;

      UseEffect(() {
        return () {
          nCalls += 1;

          expect(stateA.value, nCalls < 2 ? false : true);
          expect(stateB.value, nCalls < 3 ? 0 : 1);
          expect(stateC.value, nCalls < 4 ? "initial" : "new value");
        };
      }, [stateA, stateB, stateC], UseEffect.dispatchEffect);

      stateA.value = !stateA.value;
      stateB.value += 1;
      stateC.value = "new value";

      expect(nCalls, 3);
    });
  });
}
