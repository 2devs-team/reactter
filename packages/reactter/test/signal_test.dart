import 'package:reactter/reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shareds/test_controllers.dart';

void main() {
  group("Signal", () {
    test("should be cast away nullability", () {
      final signalNull = Signal<bool?>(false);

      expect(signalNull.value, false);
      expect(signalNull.notNull, isA<Signal<bool>>());
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

    test("should be notified manually", () {
      final signal = Signal("initial");
      int count = 0;

      Rt.one(signal, Lifecycle.didUpdate, (_, __) {
        count += 1;
      });

      signal.notify();

      expectLater(count, 1);

      signal.notify();

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

    test("should get debug label", () {
      final signal = Signal("initial", debugLabel: "signal");

      expect(signal.debugLabel, "signal");
    });

    test("should get debug info", () {
      final signal = Signal("initial");

      expect(signal.debugInfo, {"value": "initial"});

      signal("change value");

      expect(signal.debugInfo, {"value": "change value"});
    });

    test("should get value as String", () {
      final signal = Signal("initial");

      expect(signal.toString(), "initial");

      signal("change value");

      expect("$signal", "change value");
    });
  });
}
