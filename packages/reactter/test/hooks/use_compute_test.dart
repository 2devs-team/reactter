import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

void main() {
  group(
    "UseCompute",
    () {
      test(
        "should have a initial value",
        () {
          final testController = Rt.create<TestController>(
            () => TestController(),
          )!;

          expect(testController.stateCompute.value, 5);

          Rt.delete<TestController>();
        },
      );

      test(
        "should change vale when computed value is different to previus value",
        () {
          final testController = Rt.create<TestController>(
            () => TestController(),
          )!;

          final logValueChanges = [testController.stateCompute.value];
          expect(testController.stateCompute.value, 5);

          UseEffect(
            () => logValueChanges.add(testController.stateCompute.value),
            [testController.stateCompute],
          );

          testController.stateInt.value += 1;
          expect(testController.stateCompute.value, 5);

          testController.stateDouble.value += 2;
          expect(testController.stateCompute.value, 5);

          testController.stateInt.value += 3;
          expect(testController.stateCompute.value, 6);

          testController.stateDouble.value += 4;
          expect(testController.stateCompute.value, 10);

          testController.stateInt.value += 5;
          expect(testController.stateCompute.value, 10);

          expect(logValueChanges, [5, 6, 10]);

          Rt.delete<TestController>();
        },
      );

      test('should get debug label', () {
        final testController = Rt.create<TestController>(
          () => TestController(),
        )!;

        expect(testController.stateCompute.debugLabel, 'stateCompute');

        Rt.delete<TestController>();
      });

      test('should get debug info', () {
        final testController = Rt.create<TestController>(
          () => TestController(),
        )!;

        expect(
          testController.stateCompute.debugInfo,
          {
            'value': 5,
            'dependencies': [
              testController.stateInt,
              testController.stateDouble,
            ],
          },
        );

        Rt.delete<TestController>();
      });
    },
  );
}
