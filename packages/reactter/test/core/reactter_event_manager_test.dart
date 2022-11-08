import 'package:test/test.dart';
import 'package:reactter/core.dart';

import '../shareds/test_context.dart';

enum Events { TestEvent, TestEvent2 }

const TEST_EVENT_PARAM_NAME = 'TestEventParam';
const TEST_EVENT2_PARAM_NAME = 'TestEvent2Param';

const TEST_EVENT_COUNT = 3;
const TEST_EVENT2_COUNT = 2;

void main() {
  group("ReactterEventManager", () {
    test("should listens and emits event", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestContext>(),
            Events.TestEvent,
            callback,
          );
        },
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestContext>(),
            Events.TestEvent2,
            callback,
          );
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listens and emits event with id", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestContext>('uniqueId'),
            Events.TestEvent,
            callback,
          );
        },
        id: 'uniqueId',
        expectParam: "$TEST_EVENT_PARAM_NAME$TEST_EVENT_COUNT",
        expectCount: TEST_EVENT_COUNT,
      );

      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestContext>('uniqueId'),
            Events.TestEvent2,
            callback,
          );
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
          Reactter.on(
            testContext,
            Events.TestEvent,
            (TestContext? inst, String param) {
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
          Reactter.one(
            ReactterInstance<TestContext>(),
            Events.TestEvent,
            callback,
          );
        },
        expectParam: "$TEST_EVENT_PARAM_NAME${1}",
        expectCount: 1,
      );

      _testEmitListenEvent(
        (callback) {
          Reactter.one(
            ReactterInstance<TestContext>(),
            Events.TestEvent2,
            callback,
          );
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME${1}",
        expectCount: 1,
      );
    });

    test("should unlistens event", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestContext>(),
            Events.TestEvent,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestContext>(),
            Events.TestEvent,
            callback,
          );
          Reactter.on(
            ReactterInstance<TestContext>(),
            Events.TestEvent2,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestContext>(),
            Events.TestEvent2,
            callback,
          );
        },
        expectCount: 0,
      );
    });

    test("should unlistens event with id", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestContext>('uniqueId'),
            Events.TestEvent,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestContext>('uniqueId'),
            Events.TestEvent,
            callback,
          );
          Reactter.on(
            ReactterInstance<TestContext>('uniqueId'),
            Events.TestEvent2,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestContext>('uniqueId'),
            Events.TestEvent2,
            callback,
          );
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
          Reactter.one(
            testContext,
            Events.TestEvent,
            (TestContext? inst, String param) {
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
    Reactter.emit(
      ReactterInstance<TestContext>(id),
      Events.TestEvent,
      "$TEST_EVENT_PARAM_NAME${i + 1}",
    );
  }
  for (var i = 0; i < TEST_EVENT2_COUNT; i++) {
    Reactter.emit(
      ReactterInstance<TestContext>(id),
      Events.TestEvent2,
      "$TEST_EVENT2_PARAM_NAME${i + 1}",
    );
  }

  Reactter.dispose(ReactterInstance<TestContext>(id));

  if (expectParam != null) {
    expectLater(paramReceived, expectParam);
  }

  expect(countEvent, expectCount);
}
