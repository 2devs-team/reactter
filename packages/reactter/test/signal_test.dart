import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

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

      late final bool willUpdateChecked;
      late final bool didUpdateChecked;

      Rt.one(signal, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Rt.one(signal, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signal("change value");

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
    });

    test("should be updated", () {
      final signal = Signal("initial");
      late final bool willUpdateChecked;
      late final bool didUpdateChecked;

      Rt.one(signal, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Rt.one(signal, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signal.update((_) {});

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
    });

    test("should be refreshed", () {
      final signal = Signal("initial");
      int count = 0;

      Rt.one(signal, Lifecycle.didUpdate, (_, __) {
        count += 1;
      });

      signal.refresh();

      expectLater(count, 1);

      signal.refresh();

      expectLater(count, 1);
    });

    test("should be able to used on instance", () {
      late final bool willUpdateChecked;
      late final bool didUpdateChecked;

      final testController = Rt.create<TestController>(() => TestController())!;
      final signalString = testController.signalString;

      expect(signalString(), "initial");

      Rt.one(testController, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Rt.one(testController, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signalString("change signal");

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);

      Rt.destroy<TestController>();

      expect(
        () => signalString("throw a assertion error"),
        throwsA(TypeMatcher<AssertionError>()),
      );
    });

    test("should be able to used on instance with nested way", () {
      late final bool willUpdateChecked;
      late final bool didUpdateChecked;

      final test2Controller = Rt.create(() => Test2Controller())!;
      final testController = test2Controller.testController.instance!;

      final signalString = testController.signalString;

      expect(signalString(), "initial");

      Rt.one(testController, Lifecycle.willUpdate, (_, __) {
        willUpdateChecked = true;
      });
      Rt.one(testController, Lifecycle.didUpdate, (_, __) {
        didUpdateChecked = true;
      });

      signalString("change signal");

      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);

      Rt.destroy<TestController>();

      expect(
        () => signalString("throw a assertion error"),
        throwsA(TypeMatcher<AssertionError>()),
      );
    });

    test("should be able to bind to another instance", () {
      final testController = Rt.create(() => TestController())!;
      final signalString = testController.signalString;

      expect(signalString(), "initial");

      signalString("change signal");

      expect(signalString(), "change signal");

      Rt.destroy<TestController>();

      expect(
        () {
          signalString("throw a assertion error because it's been destroyed");
        },
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
