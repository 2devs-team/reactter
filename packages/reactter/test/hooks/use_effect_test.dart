import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

void main() {
  test("UseEffect should detach previous instance", () {
    final testController = Reactter.create(() => TestController());
    final uEffect = UseEffect(() {}, [], testController);

    expect(uEffect.instanceAttached, isA<TestController>());

    uEffect.detachInstance();

    expect(uEffect.instanceAttached, isNull);
  });

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

    test("should be called after instance did mount", () {
      final testController = Reactter.create(() => TestController());

      int nCalls = 0;

      UseEffect(() {
        nCalls += 1;
      }, [], testController);

      expect(nCalls, 0);

      Reactter.emit(testController!, Lifecycle.didMount);

      expect(nCalls, 1);

      Reactter.delete<TestController>();
    });

    test("should be called with DispatchEffect when it initialized later", () {
      final testController = Reactter.create(() => TestController());
      int nCalls = 0;

      late final uEffect = Reactter.lazyState(
        () {
          return UseEffect(
            () {
              nCalls += 1;
            },
            [],
            testController,
          );
        },
        UseEffect.dispatchEffect,
      );

      expect(nCalls, 0);
      expect(uEffect, isA<UseEffect>());
      expect(uEffect.instanceAttached, isA<DispatchEffect>());
      expect(uEffect.instanceAttached, isNot(isA<TestController>()));
      expect(nCalls, 1);

      Reactter.delete<TestController>();
    });

    test("shouldn't be called by instance that was not registered", () {
      final testController = TestController();
      int nCalls = 0;

      UseEffect(
        () {
          nCalls += 1;
        },
        [testController.stateString, testController.stateInt],
        testController,
      );

      expect(nCalls, 0);

      testController.stateString.value = 'other value';

      expect(nCalls, 1);

      testController.stateInt.value += 1;

      expect(nCalls, 2);
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
      final testController = Reactter.create(() => TestController())!;

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
      final testController = Reactter.create(() => TestController())!;
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
