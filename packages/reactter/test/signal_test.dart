import 'package:reactter/reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shareds/test_controllers.dart';

void main() {
  group("Signal", () {
    test("should be created by Obj", () {
      final obj = Obj(true);

      expect(obj.toSignal, isA<Signal<bool>>());
    });

    test("should be cast away nullability", () {
      final signalNull = Signal<bool?>(false);

      expect(signalNull.value, false);
      expect(signalNull.notNull, isA<Signal<bool>>());
    });

    test("should be casted to Obj", () {
      final signal = Signal(true);

      expect(signal.toObj, isA<Obj<bool>>());
    });

    test("should notifies when its value is changed", () {
      final signal = Signal("initial");

      late final willUpdateChecked;
      late final didUpdateChecked;

      Reactter.one(signal, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Reactter.one(signal, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signal("change value");

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
    });

    test("should be updated", () {
      final signal = Signal("initial");
      late final willUpdateChecked;
      late final didUpdateChecked;

      Reactter.one(signal, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Reactter.one(signal, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signal.update((_) {});

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
    });

    test("should be refreshed", () {
      final signal = Signal("initial");
      int count = 0;

      Reactter.one(signal, Lifecycle.didUpdate, (_, __) {
        count += 1;
      });

      signal.refresh();

      expectLater(count, 1);

      signal.refresh();

      expectLater(count, 1);
    });

    test("should be able to used on instance", () {
      late final willUpdateChecked;
      late final didUpdateChecked;

      final testController =
          Reactter.create<TestController>(() => TestController())!;
      final signalString = testController.signalString;

      expect(signalString(), "initial");

      Reactter.one(testController, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Reactter.one(testController, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signalString("change signal");

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);

      Reactter.destroy<TestController>();

      expect(
        () => signalString("throw a assertion error"),
        throwsA(TypeMatcher<AssertionError>()),
      );
    });

    test("should be able to used on instance with nested way", () {
      late final willUpdateChecked;
      late final didUpdateChecked;

      final test2Controller = Reactter.create(() => Test2Controller())!;
      final testController = test2Controller.testController.instance!;

      final signalString = testController.signalString;

      expect(signalString(), "initial");

      Reactter.one(testController, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Reactter.one(testController, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signalString("change signal");

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);

      Reactter.destroy<TestController>();

      expect(
        () => signalString("throw a assertion error"),
        throwsA(TypeMatcher<AssertionError>()),
      );
    });

    test("should be able to bind to another instance", () {
      final testController = Reactter.create(() => SignalTestController())!;
      final signalString = testController.signalString;

      expect(signalString(), "initial");

      signalString("change signal");

      expect(signalString(), "change signal");

      Reactter.destroy<SignalTestController>();

      expect(
        signalString("no throw a assertion error"),
        "no throw a assertion error",
      );
    });
  });
}

class SignalTestController extends TestController {
  final signalString = Signal("initial");

  SignalTestController() {
    signalString.bind(TestController());
  }
}
