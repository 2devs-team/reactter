import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import 'shareds/test_context.dart';

class MyClass {
  final String prop;

  MyClass(this.prop);
}

void main() {
  group("UseEffect's callback", () {
    test("should be called when its dependencies has changed", () {
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

    test("should be called with dispatchEffect", () {
      late final bool isCalled;

      UseEffect(() {
        isCalled = true;
      }, [], UseEffect.dispatchEffect);

      expectLater(isCalled, true);
    });

    test("should be called after context did mount", () {
      final testContext = Reactter.create(builder: () => TestContext())!;

      int nCalls = 0;

      UseEffect(() {
        nCalls += 1;
      }, [], testContext);

      final event = UseEvent.withInstance(testContext);
      event.emit(Lifecycle.didMount);

      Reactter.unregister<TestContext>();

      expect(nCalls, 1);
    });
  });

  group("UseEffect's cleaup", () {
    test("should be called after its dependencies has changed", () {
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

    test("should be called with dispatchEffect", () {
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

    test("should be called after context will unmount", () {
      final testContext = Reactter.create(builder: () => TestContext())!;

      int nCalls = 0;

      UseEffect(() {
        return () {
          nCalls += 1;
        };
      }, [], testContext);

      UseEvent.withInstance(testContext)
        ..emit(Lifecycle.didMount)
        ..emit(Lifecycle.willUnmount);

      Reactter.unregister<TestContext>();

      expect(nCalls, 1);
    });
  });
}
