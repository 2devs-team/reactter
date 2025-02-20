import 'package:reactter/reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("UseAsyncState", () {
    test("should resolve state", () async {
      final testController = TestController();
      final stateAsync = testController.stateAsync;

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.idle);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final executing = stateAsync.resolve();

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.loading);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, true);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final response = await executing;

      expect(response, "resolved");
      expect(stateAsync.value, "resolved");
      expect(stateAsync.status, UseAsyncStateStatus.done);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, true);
      expect(stateAsync.isError, false);
    });

    test("should catch error", () async {
      final testController = TestController();
      final stateAsync = testController.stateAsyncWithError;

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.idle);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final executing = stateAsync.resolve();

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.loading);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, true);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final response = await executing;

      expect(response, null);
      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.error);
      expect(stateAsync.error.toString(), "Exception: has a error");
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, true);
    });

    test("should reset state", () async {
      final testController = TestController();
      final stateAsync = testController.stateAsync;

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.idle);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final executing = stateAsync.resolve();

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.loading);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, true);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final response = await executing;

      expect(response, "resolved");
      expect(stateAsync.value, "resolved");
      expect(stateAsync.status, UseAsyncStateStatus.done);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, true);
      expect(stateAsync.isError, false);

      stateAsync.reset();

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.idle);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);
    });

    test("should resolve state with arguments", () async {
      final testController = TestController();
      final stateAsync = testController.stateAsyncWithArg;

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.idle);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final executing = stateAsync.resolve(Args1('arg1'));

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.loading);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, true);
      expect(stateAsync.isDone, false);
      expect(stateAsync.isError, false);

      final response = await executing;

      expect(response, "resolved with args: arg1");
      expect(stateAsync.value, "resolved with args: arg1");
      expect(stateAsync.status, UseAsyncStateStatus.done);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, true);
      expect(stateAsync.isError, false);

      await stateAsync.resolve(Args2('arg1', 'arg2'));

      expect(stateAsync.value, "resolved with args: arg1,arg2");
      expect(stateAsync.status, UseAsyncStateStatus.done);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, true);
      expect(stateAsync.isError, false);

      await stateAsync.resolve(Args3('arg1', 'arg2', 'arg3'));

      expect(stateAsync.value, "resolved with args: arg1,arg2,arg3");
      expect(stateAsync.status, UseAsyncStateStatus.done);
      expect(stateAsync.error, null);
      expect(stateAsync.isLoading, false);
      expect(stateAsync.isDone, true);
      expect(stateAsync.isError, false);
    });

    test("should get value when", () async {
      final testController = TestController();
      final stateAsync = testController.stateAsyncWithArg;

      final s1 = stateAsync.when<String>(idle: (value) => value);
      expect(s1, "initial");

      final futureResolve = stateAsync.resolve(Args1(null));

      final s2 = stateAsync.when<String>(loading: (value) => "loading");
      expect(s2, "loading");

      await futureResolve;

      final s3 = stateAsync.when<String>(done: (value) => value);
      expect(s3, "resolved");

      await stateAsync.resolve(Args2(null, 1));

      final s4 = stateAsync.when<String>(error: (error) => error.toString());
      expect(s4, "Exception: has a error");

      stateAsync.reset();

      final s5 = stateAsync.when<String>(idle: (value) => value);
      expect(s5, "initial");
    });

    test("should get the future", () async {
      final stateAsync = UseAsyncState(
        () async => Future.value("resolved"),
        "initial",
      );

      expect(stateAsync.future, doesNotComplete);

      await stateAsync.resolve();

      expect(stateAsync.future, completes);
      expect(await stateAsync.future, "resolved");
    });

    test("should execute a sync method", () async {
      final stateAsync = UseAsyncState(
        () => "RESOLVED",
        "initial",
      );

      await stateAsync.resolve();

      expect(stateAsync.value, "RESOLVED");
      expect(stateAsync.status, UseAsyncStateStatus.done);
    });

    test('should cancel the async function', () async {
      final stateAsync = UseAsyncState(
        () async {
          await Future.delayed(Duration(milliseconds: 100));
          return "resolved";
        },
        "initial",
      );

      final executing = stateAsync.resolve();
      stateAsync.cancel();
      await executing;

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.done);

      stateAsync.cancel();
      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");
      expect(stateAsync.status, UseAsyncStateStatus.done);
    });

    test("should get debugLabel", () {
      final testController = TestController();
      final stateAsync = testController.stateAsync;

      expect(stateAsync.debugLabel, "stateAsync");
    });

    test('should get debugInfo', () {
      final testController = TestController();
      final stateAsync = testController.stateAsync;

      expect(stateAsync.debugInfo, {
        'value': "initial",
        'error': null,
        'status': UseAsyncStateStatus.idle,
      });
    });
  });
}
