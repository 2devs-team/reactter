import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';

void main() {
  group("UseReducer", () {
    test("should has a initial value", () {
      final testContext = TestContext();

      expect(testContext.stateReduce.value.count, 0);
    });

    test("should dispatch a action", () {
      final testContext = TestContext();

      testContext.stateReduce.dispatch(IncrementAction());
      expect(testContext.stateReduce.value.count, 1);

      testContext.stateReduce
          .dispatch(ReactterAction(type: 'INCREMENT', payload: 2));
      expect(testContext.stateReduce.value.count, 3);

      expect(
        () => testContext.stateReduce
            .dispatch(ReactterAction(type: 'undefined', payload: 'undefined')),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test("should dispatch a action callable", () {
      final testContext = TestContext();

      testContext.stateReduce.dispatch(IncrementActionCallable(quantity: 2));
      expect(testContext.stateReduce.value.count, 2);

      testContext.stateReduce.dispatch(DecrementActionCallable());
      expect(testContext.stateReduce.value.count, 1);
    });

    test("should update state when dispatch action", () {
      final testContext = TestContext();
      late bool? isStateChanged;

      UseEffect(() {
        isStateChanged = true;
      }, [testContext.stateReduce]);

      testContext.stateReduce.dispatch(IncrementAction());

      expectLater(isStateChanged, true);
    });
  });
}
