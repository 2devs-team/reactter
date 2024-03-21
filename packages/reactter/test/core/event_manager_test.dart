// ignore_for_file: constant_identifier_names

import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

enum Events { TestEvent, TestEvent2 }

const TEST_EVENT_PARAM_NAME = 'TestEventParam';
const TEST_EVENT2_PARAM_NAME = 'TestEvent2Param';

const TEST_EVENT_COUNT = 3;
const TEST_EVENT2_COUNT = 2;

void main() {
  group("ReactterEventManager", () {
    test("should listen and emit event using the instance", () {
      final testController = Reactter.create(() => TestController())!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
      );

      Reactter.delete<TestController>();
    });

    test("should listen and emit event using the instance with id", () {
      final testController = Reactter.create(
        () => TestController(),
        id: 'uniqueId',
      )!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
      );

      Reactter.delete<TestController>('uniqueId');
    });

    test(
      "should listen and emit event using ReactterInstance",
      () {
        _testListenAndEmitEvent(
          ReactterInstance<TestController>(),
          ReactterInstance<TestController>(),
          instanceMatcher: isNull,
        );

        final testController = Reactter.create(() => TestController())!;

        _testListenAndEmitEvent(
          ReactterInstance<TestController>(),
          ReactterInstance<TestController>(),
          instanceMatcher: testController,
        );

        Reactter.delete<TestController>();
      },
    );

    test(
      "should listen and emit event using ReactterInstance with id",
      () {
        _testListenAndEmitEvent(
          ReactterInstance<TestController>('uniqueId'),
          ReactterInstance<TestController>('uniqueId'),
          instanceMatcher: isNull,
        );

        final testController = Reactter.create(
          () => TestController(),
          id: 'uniqueId',
        )!;

        _testListenAndEmitEvent(
          ReactterInstance<TestController>('uniqueId'),
          ReactterInstance<TestController>('uniqueId'),
          instanceMatcher: testController,
        );

        Reactter.delete<TestController>('uniqueId');
      },
    );

    test(
      "should listen event using the instance and emit event using ReactterInstance",
      () {
        final testController = Reactter.create(() => TestController())!;

        _testListenAndEmitEvent(
          testController,
          ReactterInstance<TestController>(),
          instanceMatcher: testController,
        );

        Reactter.delete<TestController>();
      },
    );

    test(
      "should listen event using the instance and emit event using ReactterInstance with id",
      () {
        final testController = Reactter.create(
          () => TestController(),
          id: 'uniqueId',
        )!;

        _testListenAndEmitEvent(
          testController,
          ReactterInstance<TestController>('uniqueId'),
          instanceMatcher: testController,
        );

        Reactter.delete<TestController>('uniqueId');
      },
    );

    test(
      "should listen event using ReactterInstance and emit event using the instance",
      () {
        final testController = Reactter.create(() => TestController())!;

        _testListenAndEmitEvent(
          ReactterInstance<TestController>(),
          testController,
          instanceMatcher: testController,
        );

        Reactter.delete<TestController>();
      },
    );

    test(
      "should listen event using ReactterInstance and emit event using the instance with id",
      () {
        final testController = Reactter.create(
          () => TestController(),
          id: 'uniqueId',
        )!;

        _testListenAndEmitEvent(
          ReactterInstance<TestController>('uniqueId'),
          testController,
          instanceMatcher: testController,
        );

        Reactter.delete<TestController>('uniqueId');
      },
    );

    test("should listen and emits event only once", () {
      final testController = Reactter.create(() => TestController())!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        ReactterInstance<TestController>(),
        ReactterInstance<TestController>(),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        testController,
        ReactterInstance<TestController>(),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        ReactterInstance<TestController>(),
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      Reactter.delete<TestController>();
    });

    test("should listen and emits event only once with id", () {
      final testController = Reactter.create(
        () => TestController(),
        id: 'uniqueId',
      )!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        ReactterInstance<TestController>('uniqueId'),
        ReactterInstance<TestController>('uniqueId'),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        testController,
        ReactterInstance<TestController>('uniqueId'),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        ReactterInstance<TestController>('uniqueId'),
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      Reactter.delete<TestController>('uniqueId');
    });
    test("should unlisten event", _testUnlistenEvent);

    test(
      "should unlisten event with id",
      () => _testUnlistenEvent(withId: true),
    );
  });
}

void _testListenAndEmitEvent(
  Object instListen,
  Object instEmit, {
  bool isOnce = false,
  Object? instanceMatcher,
}) {
  int countEvent1 = 0;
  int countEvent2 = 0;

  final listen = isOnce ? Reactter.one : Reactter.on;

  listen(instListen, Events.TestEvent, (inst, param) {
    if (instanceMatcher != null) expect(inst, instanceMatcher);
    expect(param, TEST_EVENT_PARAM_NAME);
    countEvent1 += 1;
  });

  listen(instListen, Events.TestEvent2, (inst, param) {
    if (instanceMatcher != null) expect(inst, instanceMatcher);
    expect(param, TEST_EVENT2_PARAM_NAME);
    countEvent2 += 1;
  });

  for (var i = 0; i < TEST_EVENT_COUNT; i++) {
    Reactter.emit(
      instEmit,
      Events.TestEvent,
      TEST_EVENT_PARAM_NAME,
    );
    expect(countEvent1, isOnce ? 1 : i + 1);
  }

  for (var i = 0; i < TEST_EVENT2_COUNT; i++) {
    Reactter.emit(
      instEmit,
      Events.TestEvent2,
      TEST_EVENT2_PARAM_NAME,
    );
    expect(countEvent2, isOnce ? 1 : i + 1);
  }

  Reactter.offAll(instListen);
}

void _testUnlistenEvent({bool withId = false}) {
  int countEvent1 = 0;
  int countEvent2 = 0;
  final id = withId ? 'uniqueId' : null;

  final testController = Reactter.create(() => TestController(), id: id)!;

  void onTestEvent(TestController? inst, String param) {
    countEvent1 += 1;
  }

  void onTestEvent2(TestController? inst, String param) {
    countEvent2 += 1;
  }

  Reactter.on(testController, Events.TestEvent, onTestEvent);
  Reactter.on(
    ReactterInstance<TestController>(id),
    Events.TestEvent,
    (inst, param) {
      expect(inst, testController);
      expect(param, TEST_EVENT_PARAM_NAME);
    },
  );
  Reactter.on(
    ReactterInstance<TestController>(id),
    Events.TestEvent2,
    onTestEvent2,
  );

  expect(countEvent1, 0);
  expect(countEvent2, 0);

  Reactter.emit(testController, Events.TestEvent, TEST_EVENT_PARAM_NAME);

  expect(countEvent1, 1);
  expect(countEvent2, 0);

  Reactter.emit(
    ReactterInstance<TestController>(id),
    Events.TestEvent,
    TEST_EVENT_PARAM_NAME,
  );

  expect(countEvent1, 2);
  expect(countEvent2, 0);

  Reactter.emit(
    ReactterInstance<TestController>(id),
    Events.TestEvent2,
    TEST_EVENT2_PARAM_NAME,
  );

  expect(countEvent1, 2);
  expect(countEvent2, 1);

  Reactter.off(testController, Events.TestEvent, onTestEvent);
  Reactter.emit(
    ReactterInstance<TestController>(id),
    Events.TestEvent,
    TEST_EVENT_PARAM_NAME,
  );
  Reactter.emit(testController, Events.TestEvent, TEST_EVENT_PARAM_NAME);

  expect(countEvent1, 2);
  expect(countEvent2, 1);

  Reactter.emit(testController, Events.TestEvent2, TEST_EVENT2_PARAM_NAME);

  expect(countEvent1, 2);
  expect(countEvent2, 2);

  Reactter.off(
    ReactterInstance<TestController>(id),
    Events.TestEvent2,
    onTestEvent2,
  );
  Reactter.emit(testController, Events.TestEvent2, TEST_EVENT2_PARAM_NAME);
  Reactter.emit(
    ReactterInstance<TestController>(id),
    Events.TestEvent2,
    TEST_EVENT2_PARAM_NAME,
  );

  expect(countEvent1, 2);
  expect(countEvent2, 2);

  Reactter.delete<TestController>(id);
}
