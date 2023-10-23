import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/src/framework.dart';
import 'package:reactter/src/types.dart';

import '../shareds/test_controllers.dart';

enum Events { TestEvent, TestEvent2 }

const TEST_EVENT_PARAM_NAME = 'TestEventParam';
const TEST_EVENT2_PARAM_NAME = 'TestEvent2Param';

const TEST_EVENT_COUNT = 3;
const TEST_EVENT2_COUNT = 2;

void main() {
  group("ReactterEventManager", () {
    test("should listen and emits event", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestController>(),
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
            ReactterInstance<TestController>(),
            Events.TestEvent2,
            callback,
          );
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listen and emits event with id", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestController>('uniqueId'),
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
            ReactterInstance<TestController>('uniqueId'),
            Events.TestEvent2,
            callback,
          );
        },
        id: 'uniqueId',
        expectParam: "$TEST_EVENT2_PARAM_NAME$TEST_EVENT2_COUNT",
        expectCount: TEST_EVENT2_COUNT,
      );
    });

    test("should listen and emits event with instance", () {
      late TestController? instance;
      final testController = Reactter.create(() => TestController());

      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            testController,
            Events.TestEvent,
            (TestController? inst, String param) {
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

    test("should listen and emits event only once", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.one(
            ReactterInstance<TestController>(),
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
            ReactterInstance<TestController>(),
            Events.TestEvent2,
            callback,
          );
        },
        expectParam: "$TEST_EVENT2_PARAM_NAME${1}",
        expectCount: 1,
      );
    });

    test("should unlisten event", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestController>(),
            Events.TestEvent,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestController>(),
            Events.TestEvent,
            callback,
          );
          Reactter.on(
            ReactterInstance<TestController>(),
            Events.TestEvent2,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestController>(),
            Events.TestEvent2,
            callback,
          );
        },
        expectCount: 0,
      );
    });

    test("should unlisten event with id", () {
      _testEmitListenEvent(
        (callback) {
          Reactter.on(
            ReactterInstance<TestController>('uniqueId'),
            Events.TestEvent,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestController>('uniqueId'),
            Events.TestEvent,
            callback,
          );
          Reactter.on(
            ReactterInstance<TestController>('uniqueId'),
            Events.TestEvent2,
            callback,
          );
          Reactter.off(
            ReactterInstance<TestController>('uniqueId'),
            Events.TestEvent2,
            callback,
          );
        },
        id: 'uniqueId',
        expectCount: 0,
      );
    });

    test("should listen and emits event only once with instance", () {
      late TestController? instance;
      final testController = Reactter.create(() => TestController());

      _testEmitListenEvent(
        (callback) {
          Reactter.one(
            testController,
            Events.TestEvent,
            (TestController? inst, String param) {
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
    Reactter.emit(
      ReactterInstance<TestController>(id),
      Events.TestEvent,
      "$TEST_EVENT_PARAM_NAME${i + 1}",
    );
  }
  for (var i = 0; i < TEST_EVENT2_COUNT; i++) {
    Reactter.emit(
      ReactterInstance<TestController>(id),
      Events.TestEvent2,
      "$TEST_EVENT2_PARAM_NAME${i + 1}",
    );
  }

  Reactter.offAll(ReactterInstance<TestController>(id));

  if (expectParam != null) {
    expectLater(paramReceived, expectParam);
  }

  expect(countEvent, expectCount);
}
