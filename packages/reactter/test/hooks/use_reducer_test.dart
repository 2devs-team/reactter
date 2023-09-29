import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("UseReducer", () {
    test("should have a initial value", () {
      final testController = TestController();

      expect(testController.stateReduce.value.count, 0);
    });

    test("should dispatch a action", () {
      final testController = TestController();

      testController.stateReduce.dispatch(IncrementAction());
      expect(testController.stateReduce.value.count, 1);

      testController.stateReduce
          .dispatch(ReactterAction(type: 'INCREMENT', payload: 2));
      expect(testController.stateReduce.value.count, 3);

      expect(
        () => testController.stateReduce.dispatch(
          ReactterAction(type: 'undefined', payload: 'undefined'),
        ),
        throwsA(
          isA<UnimplementedError>(),
        ),
      );
    });

    test("should dispatch a action callable", () {
      final testController = TestController();

      testController.stateReduce.dispatch(IncrementActionCallable(quantity: 2));
      expect(testController.stateReduce.value.count, 2);

      testController.stateReduce.dispatch(DecrementActionCallable());
      expect(testController.stateReduce.value.count, 1);
    });

    test("should update state when dispatch action", () {
      final testController = TestController();
      late bool? isStateChanged;

      UseEffect(() {
        isStateChanged = true;
      }, [testController.stateReduce]);

      testController.stateReduce.dispatch(IncrementAction());

      expectLater(isStateChanged, true);
    });
  });
}
