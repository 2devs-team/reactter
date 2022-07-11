import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/core.dart';
import 'package:reactter/reactter.dart';

import 'shareds/test_context.dart';

enum Events { TestEvent }

void main() {
  group("UseEvent", () {
    test("should adds and removes event", () => _testAddAndRemoveEvent());

    test("should adds and removes event with id",
        () => _testAddAndRemoveEvent("uniqueId"));

    test(
      "should emits and listens event",
      () => _testEmitListenEvent(
        (CallbackEvent<TestContext?, String> callback) =>
            UseEvent<TestContext>().on<String>(Events.TestEvent, callback),
        "withParam3",
        3,
      ),
    );

    test("should emits and listens event with instance", () {
      late TestContext? instance;
      final testContext = Reactter.create(builder: () => TestContext());

      _testEmitListenEvent(
        (CallbackEvent<TestContext?, String> callback) {
          UseEvent.withInstance(testContext).on<String>(
            Events.TestEvent,
            (inst, param) {
              instance = inst;
              callback(inst, param);
            },
          );
        },
        "withParam3",
        3,
      );

      Reactter.delete<TestContext>();

      expectLater(instance, isInstanceOf<TestContext>());
      expectLater(instance, testContext);
    });

    test(
      "should emits and listens event only once",
      () => _testEmitListenEvent(
        (CallbackEvent<TestContext?, String> callback) =>
            UseEvent<TestContext>().one<String>(Events.TestEvent, callback),
        "withParam1",
        1,
      ),
    );

    test("should emits and listens event only once with instance", () {
      late TestContext? instance;
      final testContext = Reactter.create(builder: () => TestContext());

      _testEmitListenEvent(
        (CallbackEvent<TestContext?, String> callback) {
          UseEvent.withInstance(testContext).one<String>(
            Events.TestEvent,
            (inst, param) {
              instance = inst;
              callback(inst, param);
            },
          );
        },
        "withParam1",
        1,
      );

      Reactter.delete<TestContext>();

      expectLater(instance, isInstanceOf<TestContext>());
      expectLater(instance, testContext);
    });

    test("should listens instance's life-cycle event", () {
      late TestContext? instance;
      late bool willUpdateChecked;
      late bool didUpdateChecked;
      late bool isDestroyed;

      UseEvent<TestContext>()
        ..on(LifeCycle.initialized, (inst, __) {
          instance = inst;
        })
        ..on<UseState>(LifeCycle.willUpdate, (_, hook) {
          willUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "initial");
        })
        ..on<UseState>(LifeCycle.didUpdate, (_, hook) {
          didUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "changed");
        })
        ..on(LifeCycle.destroyed, (_, __) {
          isDestroyed = true;
        });

      final testContext = Reactter.create(builder: () => TestContext());
      testContext?.stateString.value = "changed";

      Reactter.delete<TestContext>();

      expectLater(instance, isInstanceOf<TestContext>());
      expectLater(instance, testContext);
      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
      expectLater(isDestroyed, true);
    });
  });
}

void _testAddAndRemoveEvent([String? id]) {
  final instanceManager = ReactterInstance<TestContext?>(id);

  void eventCallback(_, __) {}

  UseEvent<TestContext>(id).on(Events.TestEvent, eventCallback);

  expect(
    Reactter.factory.events[instanceManager]?[Events.TestEvent]
        ?.contains(eventCallback),
    true,
  );

  UseEvent<TestContext>(id).off(Events.TestEvent, eventCallback);

  expect(Reactter.factory.events.isEmpty, true);
}

void _testEmitListenEvent(
  Function(CallbackEvent<TestContext?, String> callback) eventCb,
  String expectParam,
  int expectCount,
) {
  late String? paramReceived;
  int countEvent = 0;

  eventCb(
    (instance, param) {
      paramReceived = param;
      countEvent += 1;
    },
  );

  UseEvent<TestContext>()
    ..emit(Events.TestEvent, "withParam1")
    ..emit(Events.TestEvent, "withParam2")
    ..emit(Events.TestEvent, "withParam3")
    ..dispose();

  Reactter.delete<TestContext>();

  expectLater(paramReceived, expectParam);
  expect(countEvent, expectCount);
}
