import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("ReactterMemo", () {
    test("should be a class callable with arguments", () async {
      final memo = ReactterMemo((Args args) {});

      expect(memo.call, isA<Function(Args)>());
    });

    test("should memoized the returned value by the function with arguments",
        () async {
      final testController = TestController();

      final timeStart = DateTime.now();
      testController.fibonacciMemo(Args1(100));
      final timeLasted = DateTime.now().difference(timeStart);

      final timeStart2 = DateTime.now();
      testController.fibonacciMemo(Args1(100));
      final timeLasted2 = DateTime.now().difference(timeStart2);

      // should be up to x10 faster
      expect(timeLasted.inMicroseconds / 10 > timeLasted2.inMicroseconds, true);
    });

    test("should memoized the returned value by the function without arguments",
        () async {
      final testController = TestController();

      final timeStart = DateTime.now();
      testController.fibonacciMemo(null);
      final timeLasted = DateTime.now().difference(timeStart);

      final timeStart2 = DateTime.now();
      testController.fibonacciMemo(null);
      final timeLasted2 = DateTime.now().difference(timeStart2);

      // should be up to x10 faster
      expect(timeLasted.inMicroseconds / 10 > timeLasted2.inMicroseconds, true);
    });
  });
}
