import 'package:test/test.dart';
import 'package:reactter/core.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';

enum Events { TestEvent, TestEvent2 }

const TEST_EVENT_PARAM_NAME = 'TestEventParam';
const TEST_EVENT2_PARAM_NAME = 'TestEvent2Param';

const TEST_EVENT_COUNT = 3;
const TEST_EVENT2_COUNT = 2;

void main() {
  group("UseEvent", () {
    test("should listens and emits event", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>().on(Events.TestEvent, callback);
        },
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>().on(Events.TestEvent2, callback);
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listens and emits event with id", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>('uniqueId').on(Events.TestEvent, callback);
        },
        id: 'uniqueId',
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>('uniqueId').on(Events.TestEvent2, callback);
        },
        id: 'uniqueId',
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listens and emits event with instance", () {
      late TestContext? instance;
      final testContext = Reactter.create(builder: () => TestContext());

      _testEmitListenEvent(
        (callback) {
          UseEvent.withInstance(testContext).on<String>(
            Events.TestEvent,
            (inst, param) {
              instance = inst;
              callback(inst, param);
            },
          );
        },
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      Reactter.delete<TestContext>();

      expectLater(instance, isA<TestContext>());
      expectLater(instance, testContext);
    });

    test("should listens and emits event only once", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>().one<String>(Events.TestEvent, callback);
        },
        expectParam: "$TEST_EVENT_PARAM_NAME${1}",
        expectCount: 1,
      );

      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>().one<String>(Events.TestEvent2, callback);
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME${1}",
        expectCount: 1,
      );
    });

    test("should unlistens event", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>()
            ..on(Events.TestEvent, callback)
            ..off(Events.TestEvent, callback);

          UseEvent<TestContext>()
            ..on(Events.TestEvent2, callback)
            ..off(Events.TestEvent2, callback);
        },
        expectCount: 0,
      );
    });

    test("should unlistens event with id", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestContext>('uniqueId')
            ..on(Events.TestEvent, callback)
            ..off(Events.TestEvent, callback);

          UseEvent<TestContext>('uniqueId')
            ..on(Events.TestEvent2, callback)
            ..off(Events.TestEvent2, callback);
        },
        id: 'uniqueId',
        expectCount: 0,
      );
    });

    test("should listens and emits event only once with instance", () {
      late TestContext? instance;
      final testContext = Reactter.create(builder: () => TestContext());

      _testEmitListenEvent(
        (callback) {
          UseEvent.withInstance(testContext).one<String>(
            Events.TestEvent,
            (inst, param) {
              instance = inst;
              callback(inst, param);
            },
          );
        },
        expectParam: "$TEST_EVENT_PARAM_NAME${1}",
        expectCount: 1,
      );

      Reactter.delete<TestContext>();

      expectLater(instance, isA<TestContext>());
      expectLater(instance, testContext);
    });

    test("should listens instance's life-cycle event", () {
      late TestContext? instance;
      late bool willUpdateChecked;
      late bool didUpdateChecked;
      late bool isDestroyed;

      UseEvent<TestContext>()
        ..on(Lifecycle.initialized, (inst, __) {
          instance = inst;
        })
        ..on(Lifecycle.willUpdate, (_, UseState hook) {
          willUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "initial");
        })
        ..on(Lifecycle.didUpdate, (_, UseState hook) {
          didUpdateChecked = true;
          expect(hook, instance?.stateString);
          expect(hook.value, "changed");
        })
        ..on(Lifecycle.destroyed, (_, __) {
          isDestroyed = true;
        });

      final testContext = Reactter.create(builder: () => TestContext());
      testContext?.stateString.value = "changed";

      Reactter.delete<TestContext>();

      expectLater(instance, isA<TestContext>());
      expectLater(instance, testContext);
      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
      expectLater(isDestroyed, true);
    });
  });
}

void _testEmitListenEvent(
  Function(CallbackEvent<TestContext?, String> callback) eventCb, {
  String? id,
  required int expectCount,
  String? expectParam,
}) {
  late String? paramReceived;
  int countEvent = 0;

  eventCb((instance, param) {
    paramReceived = param;
    countEvent += 1;
  });

  for (var i = 0; i < TEST_EVENT_COUNT; i++) {
    UseEvent<TestContext>(id)
        .emit(Events.TestEvent, "$TEST_EVENT_PARAM_NAME${i + 1}");
  }
  for (var i = 0; i < TEST_EVENT2_COUNT; i++) {
    UseEvent<TestContext>(id)
        .emit(Events.TestEvent2, "$TEST_EVENT2_PARAM_NAME${i + 1}");
  }

  UseEvent<TestContext>(id).dispose();

  if (expectParam != null) {
    expectLater(paramReceived, expectParam);
  }

  expect(countEvent, expectCount);
}
