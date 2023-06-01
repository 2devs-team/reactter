import 'package:test/test.dart';
import 'package:reactter/core.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

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
          UseEvent<TestController>().on(Events.TestEvent, callback);
        },
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>().on(Events.TestEvent2, callback);
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listens and emits event with id", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>('uniqueId').on(Events.TestEvent, callback);
        },
        id: 'uniqueId',
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>('uniqueId').on(Events.TestEvent2, callback);
        },
        id: 'uniqueId',
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listens and emits event with instance", () {
      late TestController? instance;
      final testController = Reactter.create(builder: () => TestController());

      _testEmitListenEvent(
        (callback) {
          UseEvent.withInstance(testController).on<String>(
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

      Reactter.delete<TestController>();

      expectLater(instance, isA<TestController>());
      expectLater(instance, testController);
    });

    test("should listens and emits event only once", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>().one<String>(Events.TestEvent, callback);
        },
        expectParam: "$TEST_EVENT_PARAM_NAME${1}",
        expectCount: 1,
      );

      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>().one<String>(Events.TestEvent2, callback);
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME${1}",
        expectCount: 1,
      );
    });

    test("should unlistens event", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>()
            ..on(Events.TestEvent, callback)
            ..off(Events.TestEvent, callback);

          UseEvent<TestController>()
            ..on(Events.TestEvent2, callback)
            ..off(Events.TestEvent2, callback);
        },
        expectCount: 0,
      );
    });

    test("should unlistens event with id", () {
      _testEmitListenEvent(
        (callback) {
          UseEvent<TestController>('uniqueId')
            ..on(Events.TestEvent, callback)
            ..off(Events.TestEvent, callback);

          UseEvent<TestController>('uniqueId')
            ..on(Events.TestEvent2, callback)
            ..off(Events.TestEvent2, callback);
        },
        id: 'uniqueId',
        expectCount: 0,
      );
    });

    test("should listens and emits event only once with instance", () {
      late TestController? instance;
      final testController = Reactter.create(builder: () => TestController());

      _testEmitListenEvent(
        (callback) {
          UseEvent.withInstance(testController).one<String>(
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

      Reactter.delete<TestController>();

      expectLater(instance, isA<TestController>());
      expectLater(instance, testController);
    });

    test("should listens instance's life-cycle event", () {
      late TestController? instance;
      late bool willUpdateChecked;
      late bool didUpdateChecked;
      late bool isDestroyed;

      UseEvent<TestController>()
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

      final testController = Reactter.create(builder: () => TestController());
      testController?.stateString.value = "changed";

      Reactter.delete<TestController>();

      expectLater(instance, isA<TestController>());
      expectLater(instance, testController);
      expectLater(willUpdateChecked, true);
      expectLater(didUpdateChecked, true);
      expectLater(isDestroyed, true);
    });
  });
}

void _testEmitListenEvent(
  Function(CallbackEvent<TestController?, String> callback) eventCb, {
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
    UseEvent<TestController>(id)
        .emit(Events.TestEvent, "$TEST_EVENT_PARAM_NAME${i + 1}");
  }
  for (var i = 0; i < TEST_EVENT2_COUNT; i++) {
    UseEvent<TestController>(id)
        .emit(Events.TestEvent2, "$TEST_EVENT2_PARAM_NAME${i + 1}");
  }

  UseEvent<TestController>(id).dispose();

  if (expectParam != null) {
    expectLater(paramReceived, expectParam);
  }

  expect(countEvent, expectCount);
}
