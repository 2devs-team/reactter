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
  group("EventHandler", () {
    test("should listen and emit event using dependency", () {
      final testController = Rt.create(() => TestController())!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
      );

      Rt.delete<TestController>();
    });

    test("should listen and emit event using dependency with id", () {
      final testController = Rt.create(
        () => TestController(),
        id: 'uniqueId',
      )!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
      );

      Rt.delete<TestController>('uniqueId');
    });

    test(
      "should listen and emit event using RtDependency",
      () {
        _testListenAndEmitEvent(
          RtDependency<TestController>(),
          RtDependency<TestController>(),
          instanceMatcher: isNull,
        );

        final testController = Rt.create(() => TestController())!;

        _testListenAndEmitEvent(
          RtDependency<TestController>(),
          RtDependency<TestController>(),
          instanceMatcher: testController,
        );

        Rt.delete<TestController>();
      },
    );

    test(
      "should listen and emit event using RtDependency with id",
      () {
        _testListenAndEmitEvent(
          RtDependency<TestController>('uniqueId'),
          RtDependency<TestController>('uniqueId'),
          instanceMatcher: isNull,
        );

        final testController = Rt.create(
          () => TestController(),
          id: 'uniqueId',
        )!;

        _testListenAndEmitEvent(
          RtDependency<TestController>('uniqueId'),
          RtDependency<TestController>('uniqueId'),
          instanceMatcher: testController,
        );

        Rt.delete<TestController>('uniqueId');
      },
    );

    test(
      "should listen event using dependency and emit event using RtDependency",
      () {
        final testController = Rt.create(() => TestController())!;

        _testListenAndEmitEvent(
          testController,
          RtDependency<TestController>(),
          instanceMatcher: testController,
        );

        Rt.delete<TestController>();
      },
    );

    test(
      "should listen event using the dependency and emit event using RtDependency with id",
      () {
        final testController = Rt.create(
          () => TestController(),
          id: 'uniqueId',
        )!;

        _testListenAndEmitEvent(
          testController,
          RtDependency<TestController>('uniqueId'),
          instanceMatcher: testController,
        );

        Rt.delete<TestController>('uniqueId');
      },
    );

    test(
      "should listen event using RtDependency and emit event using the dependency",
      () {
        final testController = Rt.create(() => TestController())!;

        _testListenAndEmitEvent(
          RtDependency<TestController>(),
          testController,
          instanceMatcher: testController,
        );

        Rt.delete<TestController>();
      },
    );

    test(
      "should listen event using RtDependency and emit event using the dependency with id",
      () {
        final testController = Rt.create(
          () => TestController(),
          id: 'uniqueId',
        )!;

        _testListenAndEmitEvent(
          RtDependency<TestController>('uniqueId'),
          testController,
          instanceMatcher: testController,
        );

        Rt.delete<TestController>('uniqueId');
      },
    );

    test("should listen and emits event only once", () {
      final testController = Rt.create(() => TestController())!;

      _testListenAndEmitEvent(
        testController,
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        RtDependency<TestController>(),
        RtDependency<TestController>(),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        testController,
        RtDependency<TestController>(),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        RtDependency<TestController>(),
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      Rt.delete<TestController>();
    });

    test("should listen and emits event only once with id", () {
      final testController = Rt.create(
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
        RtDependency<TestController>('uniqueId'),
        RtDependency<TestController>('uniqueId'),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        testController,
        RtDependency<TestController>('uniqueId'),
        instanceMatcher: testController,
        isOnce: true,
      );

      _testListenAndEmitEvent(
        RtDependency<TestController>('uniqueId'),
        testController,
        instanceMatcher: testController,
        isOnce: true,
      );

      Rt.delete<TestController>('uniqueId');
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

  final listen = isOnce ? Rt.one : Rt.on;

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
    Rt.emit(
      instEmit,
      Events.TestEvent,
      TEST_EVENT_PARAM_NAME,
    );
    expect(countEvent1, isOnce ? 1 : i + 1);
  }

  for (var i = 0; i < TEST_EVENT2_COUNT; i++) {
    Rt.emit(
      instEmit,
      Events.TestEvent2,
      TEST_EVENT2_PARAM_NAME,
    );
    expect(countEvent2, isOnce ? 1 : i + 1);
  }

  Rt.offAll(instListen, true);
}

void _testUnlistenEvent({bool withId = false}) {
  int countEvent1 = 0;
  int countEvent2 = 0;
  final id = withId ? 'uniqueId' : null;

  final testController = Rt.create(() => TestController(), id: id)!;

  void onTestEvent(TestController? inst, String param) {
    countEvent1 += 1;
  }

  void onTestEvent2(TestController? inst, String param) {
    countEvent2 += 1;
  }

  Rt.on(testController, Events.TestEvent, onTestEvent);
  Rt.on(
    RtDependency<TestController>(id),
    Events.TestEvent,
    (inst, param) {
      expect(inst, testController);
      expect(param, TEST_EVENT_PARAM_NAME);
    },
  );
  Rt.on(
    RtDependency<TestController>(id),
    Events.TestEvent2,
    onTestEvent2,
  );

  expect(countEvent1, 0);
  expect(countEvent2, 0);

  Rt.emit(testController, Events.TestEvent, TEST_EVENT_PARAM_NAME);

  expect(countEvent1, 1);
  expect(countEvent2, 0);

  Rt.emit(
    RtDependency<TestController>(id),
    Events.TestEvent,
    TEST_EVENT_PARAM_NAME,
  );

  expect(countEvent1, 2);
  expect(countEvent2, 0);

  Rt.emit(
    RtDependency<TestController>(id),
    Events.TestEvent2,
    TEST_EVENT2_PARAM_NAME,
  );

  expect(countEvent1, 2);
  expect(countEvent2, 1);

  Rt.off(testController, Events.TestEvent, onTestEvent);
  Rt.emit(
    RtDependency<TestController>(id),
    Events.TestEvent,
    TEST_EVENT_PARAM_NAME,
  );
  Rt.emit(testController, Events.TestEvent, TEST_EVENT_PARAM_NAME);

  expect(countEvent1, 2);
  expect(countEvent2, 1);

  Rt.emit(testController, Events.TestEvent2, TEST_EVENT2_PARAM_NAME);

  expect(countEvent1, 2);
  expect(countEvent2, 2);

  Rt.off(
    RtDependency<TestController>(id),
    Events.TestEvent2,
    onTestEvent2,
  );
  Rt.emit(testController, Events.TestEvent2, TEST_EVENT2_PARAM_NAME);
  Rt.emit(
    RtDependency<TestController>(id),
    Events.TestEvent2,
    TEST_EVENT2_PARAM_NAME,
  );

  expect(countEvent1, 2);
  expect(countEvent2, 2);

  Rt.delete<TestController>(id);
}
