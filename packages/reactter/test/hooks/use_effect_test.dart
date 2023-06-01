import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

class MyClass {
  final String prop;

  MyClass(this.prop);
}

void main() {
  group("UseEffect's callback", () {
    test("should be called when its dependencies has changed", () {
      final testController = TestController();
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;

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
      final testController = Reactter.create(builder: () => TestController())!;

      int nCalls = 0;

      UseEffect(() {
        nCalls += 1;
      }, [], testController);

      Reactter.emit(testController, Lifecycle.didMount);

      Reactter.unregister<TestController>();

      expect(nCalls, 1);
    });
  });

  group("UseEffect's cleaup", () {
    test("should be called after its dependencies has changed", () {
      final testController = TestController();
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;
      final stateC = testController.stateString;

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
      final testController = TestController();
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;
      final stateC = testController.stateString;

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
      final testController = Reactter.create(builder: () => TestController())!;

      int nCalls = 0;

      UseEffect(() {
        return () {
          nCalls += 1;
        };
      }, [], testController);

      Reactter.emit(testController, Lifecycle.didMount);
      Reactter.emit(testController, Lifecycle.willUnmount);

      Reactter.unregister<TestController>();

      expect(nCalls, 1);
    });

    test("should be called after context will unmount with dependencies", () {
      final testController = Reactter.create(builder: () => TestController())!;
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;
      final stateC = testController.stateString;

      int nCalls = 0;

      UseEffect(
        () {
          return () {
            nCalls += 1;
          };
        },
        [stateA, stateB, stateC],
        testController,
      );

      Reactter.emit(testController, Lifecycle.didMount);
      Reactter.emit(testController, Lifecycle.willUnmount);

      Reactter.unregister<TestController>();

      expect(nCalls, 1);
    });
  });
}
