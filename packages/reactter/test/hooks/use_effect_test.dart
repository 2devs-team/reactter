import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

void main() {
  test("UseEffect should detach previous instance", () {
    final testController = Rt.create(() => TestController());
    final uEffect = UseEffect(() {}, [])..bind(testController!);

    expect(uEffect.boundInstance, isA<TestController>());

    uEffect.unbind();

    expect(uEffect.boundInstance, isNull);

    Rt.delete<TestController>();
  });

  group("UseEffect's callback", () {
    test("shouldn't be called without dependencies and an instance binded", () {
      bool isCalled = false;

      UseEffect(() {
        isCalled = true;
      }, []);

      expect(isCalled, false);
    });

    test("should be called initially, if the effect is run", () {
      final testController = Rt.create(() => UseEffectTestController())!;

      int nCalls = 0;

      UseEffect.runOnInit(() {
        nCalls += 1;
      }, []);

      expect(nCalls, 1);
      expect(testController.nCalls1, 0);
      expect(testController.nCalls2, 1);
      expect(testController.nCalls3, 0);
      expect(testController.nCalls4, 1);
      expect(testController.nCalls5, 0);
      expect(testController.nCalls6, 1);

      Rt.delete<UseEffectTestController>();
    });

    test("should be called when its dependencies has changed", () {
      final testController = Rt.create(() => UseEffectTestController())!;
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;

      int nCalls = 0;

      UseEffect(() {
        nCalls += 1;

        if (nCalls == 1) {
          expect(stateA.value, true);
          expect(stateB.value, 0);
        } else {
          expect(stateA.value, true);
          expect(stateB.value, 1);
        }
      }, [stateA, stateB]);

      expect(nCalls, 0);
      expect(testController.nCalls1, 0);
      expect(testController.nCalls2, 1);
      expect(testController.nCalls3, 0);
      expect(testController.nCalls4, 1);
      expect(testController.nCalls5, 0);
      expect(testController.nCalls6, 1);

      stateA.value = !stateA.value;

      expect(nCalls, 1);
      expect(testController.nCalls1, 1);
      expect(testController.nCalls2, 2);
      expect(testController.nCalls3, 1);
      expect(testController.nCalls4, 2);
      expect(testController.nCalls5, 1);
      expect(testController.nCalls6, 2);

      stateB.value += 1;

      expect(nCalls, 2);
      expect(testController.nCalls1, 2);
      expect(testController.nCalls2, 3);
      expect(testController.nCalls3, 2);
      expect(testController.nCalls4, 3);
      expect(testController.nCalls5, 2);
      expect(testController.nCalls6, 3);

      Rt.delete<UseEffectTestController>();
    });

    test("should be called after instance did mount", () {
      final testController = Rt.create(() => UseEffectTestController())!;

      int nCalls = 0;

      UseEffect(() {
        nCalls += 1;
      }, []).bind(testController);

      expect(nCalls, 0);
      expect(testController.nCalls1, 0);
      expect(testController.nCalls2, 1);
      expect(testController.nCalls3, 0);
      expect(testController.nCalls4, 1);
      expect(testController.nCalls5, 0);
      expect(testController.nCalls6, 1);

      Rt.emit(testController, Lifecycle.didMount);

      expect(nCalls, 1);
      expect(testController.nCalls1, 1);
      expect(testController.nCalls2, 2);
      expect(testController.nCalls3, 1);
      expect(testController.nCalls4, 2);
      expect(testController.nCalls5, 0);
      expect(testController.nCalls6, 1);

      Rt.delete<UseEffectTestController>();
    });

    test("should be called with DispatchEffect when it initialized later", () {
      final testController = UseEffectDispatchController();
      int nCalls = 0;

      late final uEffect = Rt.lazyState(
        () {
          return UseEffect(
            () {
              nCalls += 1;
            },
            [],
          );
        },
        testController,
      );

      expect(nCalls, 0);
      expect(uEffect, isA<UseEffect>());
      expect(uEffect.boundInstance, isA<DispatchEffect>());
      expect(nCalls, 1);
    });

    test("shouldn't be called by instance that was not registered", () {
      final testController = TestController();
      int nCalls = 0;

      UseEffect(
        () {
          nCalls += 1;
        },
        [testController.stateBool, testController.stateInt],
      );

      expect(nCalls, 0);

      testController.stateBool.value = !testController.stateBool.value;

      expect(nCalls, 1);

      testController.stateInt.value += 1;

      expect(nCalls, 2);
    });
  });

  group("UseEffect's cleaup", () {
    test("should be called after its dependencies has changed", () {
      final testController = Rt.create(() => UseEffectTestController())!;
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;
      final stateC = testController.signalString;

      int nCalls = 0;

      UseEffect(() {
        return () {
          nCalls += 1;

          if (nCalls == 1) {
            expect(stateA.value, true);
            expect(stateB.value, 0);
            expect(stateC.value, "initial");
          } else if (nCalls == 2) {
            expect(stateA.value, true);
            expect(stateB.value, 1);
            expect(stateC.value, "initial");
          } else if (nCalls == 3) {
            expect(stateA.value, true);
            expect(stateB.value, 1);
            expect(stateC.value, "new value");
          }
        };
      }, [stateA, stateB, stateC]);

      expect(nCalls, 0);
      expect(testController.nCleanupCalls1, 0);
      expect(testController.nCleanupCalls2, 0);
      expect(testController.nCleanupCalls3, 0);
      expect(testController.nCleanupCalls4, 0);
      expect(testController.nCleanupCalls5, 0);
      expect(testController.nCleanupCalls6, 0);

      stateA.value = !stateA.value;

      expect(nCalls, 0);
      expect(testController.nCleanupCalls1, 0);
      expect(testController.nCleanupCalls2, 1);
      expect(testController.nCleanupCalls3, 0);
      expect(testController.nCleanupCalls4, 1);
      expect(testController.nCleanupCalls5, 0);
      expect(testController.nCleanupCalls6, 1);

      stateB.value += 1;

      expect(nCalls, 1);
      expect(testController.nCleanupCalls1, 1);
      expect(testController.nCleanupCalls2, 2);
      expect(testController.nCleanupCalls3, 1);
      expect(testController.nCleanupCalls4, 2);
      expect(testController.nCleanupCalls5, 1);
      expect(testController.nCleanupCalls6, 2);

      stateC.value += "new value";

      expect(nCalls, 2);
      expect(testController.nCleanupCalls1, 2);
      expect(testController.nCleanupCalls2, 3);
      expect(testController.nCleanupCalls3, 2);
      expect(testController.nCleanupCalls4, 3);
      expect(testController.nCleanupCalls5, 2);
      expect(testController.nCleanupCalls6, 3);

      Rt.delete<UseEffectTestController>();
    });

    test("should be called with dispatchEffect", () {
      final testController = TestController();
      final stateA = testController.stateBool;
      final stateB = testController.stateInt;
      final stateC = testController.signalString;

      int nCalls = 0;

      UseEffect(
        () {
          return () {
            nCalls += 1;

            if (nCalls == 1) {
              expect(stateA.value, true);
              expect(stateB.value, 0);
              expect(stateC.value, "initial");
            } else if (nCalls == 2) {
              expect(stateA.value, true);
              expect(stateB.value, 1);
              expect(stateC.value, "initial");
            } else if (nCalls == 3) {
              expect(stateA.value, true);
              expect(stateB.value, 1);
              expect(stateC.value, "new value");
            }
          };
        },
        [stateA, stateB, stateC],
      ).bind(UseEffectDispatchController());

      expect(nCalls, 0);
      stateA.value = !stateA.value;
      expect(nCalls, 1);
      stateB.value += 1;
      expect(nCalls, 2);
      stateC.value = "new value";
      expect(nCalls, 3);
    });

    test("should be called after context will unmount", () {
      final testController = Rt.create(() => UseEffectTestController())!;

      int nCalls = 0;

      UseEffect(() {
        return () {
          nCalls += 1;
        };
      }, []).bind(testController);

      expect(nCalls, 0);
      expect(testController.nCleanupCalls1, 0);
      expect(testController.nCleanupCalls2, 0);
      expect(testController.nCleanupCalls3, 0);
      expect(testController.nCleanupCalls4, 0);
      expect(testController.nCleanupCalls5, 0);
      expect(testController.nCleanupCalls6, 0);

      Rt.emit(testController, Lifecycle.didMount);

      expect(nCalls, 0);
      expect(testController.nCleanupCalls1, 0);
      expect(testController.nCleanupCalls2, 1);
      expect(testController.nCleanupCalls3, 0);
      expect(testController.nCleanupCalls4, 1);
      expect(testController.nCleanupCalls5, 0);
      expect(testController.nCleanupCalls6, 0);

      Rt.emit(testController, Lifecycle.willUnmount);

      expect(nCalls, 1);
      expect(testController.nCleanupCalls1, 1);
      expect(testController.nCleanupCalls2, 2);
      expect(testController.nCleanupCalls3, 1);
      expect(testController.nCleanupCalls4, 2);
      expect(testController.nCleanupCalls5, 0);
      expect(testController.nCleanupCalls6, 0);

      Rt.unregister<UseEffectTestController>();
    });
  });
}

class UseEffectDispatchController extends DispatchEffect {}

class UseEffectTestController extends TestController {
  final testControllerInner = TestController();

  int nCalls1 = 0;
  int nCalls2 = 0;
  int nCalls3 = 0;
  int nCalls4 = 0;
  int nCalls5 = 0;
  int nCalls6 = 0;
  int nCleanupCalls1 = 0;
  int nCleanupCalls2 = 0;
  int nCleanupCalls3 = 0;
  int nCleanupCalls4 = 0;
  int nCleanupCalls5 = 0;
  int nCleanupCalls6 = 0;

  UseEffectTestController() {
    UseEffect(() {
      nCalls1 += 1;
      return () => nCleanupCalls1 += 1;
    }, [stateBool, stateInt, signalString]);

    UseEffect.runOnInit(() {
      nCalls2 += 1;
      return () => nCleanupCalls2 += 1;
    }, [stateBool, stateInt, signalString]);

    UseEffect(() {
      nCalls3 += 1;
      return () => nCleanupCalls3 += 1;
    }, [stateBool, stateInt, signalString]).bind(this);

    UseEffect.runOnInit(() {
      nCalls4 += 1;
      return () => nCleanupCalls4 += 1;
    }, [stateBool, stateInt, signalString]).bind(this);

    UseEffect(() {
      nCalls5 += 1;
      return () => nCleanupCalls5 += 1;
    }, [stateBool, stateInt, signalString]).bind(testControllerInner);

    UseEffect.runOnInit(() {
      nCalls6 += 1;
      return () => nCleanupCalls6 += 1;
    }, [stateBool, stateInt, signalString]).bind(testControllerInner);
  }
}
