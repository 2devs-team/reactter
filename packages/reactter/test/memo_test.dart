import 'package:fake_async/fake_async.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/src/memo/memo.dart';
import 'package:test/test.dart';

import 'shareds/test_controllers.dart';

void main() {
  group("Memo", () {
    test("should be a class callable with arguments", () {
      final testController = TestController();

      expect(testController.memo.call, isA<Function(Args)>());
    });

    test("should memoize the returned value by the calculate function", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));
      final value0Cached = testController.memo(null);
      final value1Cached = testController.memo(Args1(1));
      final value2Cached = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, true);
      expect(value1 == value1Cached, true);
      expect(value2 == value2Cached, true);
    });

    test("should override the cached value", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));
      final value0Cached = testController.memo(null, overrideCache: true);
      final value1Cached = testController.memo(Args1(1), overrideCache: true);
      final value2Cached = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, false);
      expect(value1 == value1Cached, false);
      expect(value2 == value2Cached, true);
    });

    test("should remove all cached data", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));

      testController.memo.clear();

      final newValue0 = testController.memo(null);
      final newValue1 = testController.memo(Args1(1));
      final newValue2 = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == newValue0, false);
      expect(value1 == newValue1, false);
      expect(value2 == newValue2, false);
    });

    test("should removed the cached data", () {
      final testController = TestController();

      final value0 = testController.memo(null);
      final value1 = testController.memo(Args1(1));
      final value2 = testController.memo(Args2(1, 2));

      testController.memo.remove(null);
      testController.memo.remove(Args1(1));

      final newValue0 = testController.memo(null);
      final newValue1 = testController.memo(Args1(1));
      final newValue2 = testController.memo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == newValue0, false);
      expect(value1 == newValue1, false);
      expect(value2 == newValue2, true);
    });

    test("shouldn't memoize when an error occurs", () {
      final testController = TestController();

      expect(
        () => testController.memo(Args1(ArgumentError())),
        throwsA(TypeMatcher<ArgumentError>()),
      );
    });

    test(
        "shouldn't memoize when an error Future occurs "
        "using AsyncMemoSafe interceptor", () async {
      final memo = Memo<Future<dynamic>, Args1<Error>>(
        (Args1 args) {
          return Future.error(args.arg1);
        },
        MemoSafeAsyncInterceptor(),
      );
      final arg = Args1(ArgumentError());
      final valueFuture = memo(arg);
      final valueFromCache = memo.get(arg);

      try {
        await Future.sync(() => valueFuture);
      } catch (_) {}

      final valueFromCache2 = memo.get(arg);

      expect(valueFuture, valueFromCache);
      expect(valueFuture == valueFromCache2, false);
      expect(valueFromCache2, isNull);
    });

    test(
        "should memoize for a period of time "
        "using TemporaryCacheMemo interceptor", () {
      fakeAsync((async) {
        final memo = Memo<dynamic, Args1>(
          (Args1 args) => args.arg1,
          TemporaryCacheMemo(
            Duration(minutes: 1),
          ),
        );
        final arg = Args1('test');

        final res = memo(arg);
        expect(res, 'test');

        async.elapse(Duration(seconds: 5));

        final res2 = memo.get(arg);
        expect(res2, 'test');

        async.elapse(Duration(seconds: 55));

        final res3 = memo.get(arg);
        expect(res3, isNull);
      });
    });

    test(
        "should notify events during the memoization process "
        "using MemoInterceptors and MemoInterceptorWrapper", () {
      int nCallOnInit = 0;
      int nCallOnValue = 0;
      int nCallOnValueFromCache = 0;
      int nCallOnError = 0;
      int nCallOnFinish = 0;
      dynamic lastValue;
      dynamic lastError;

      final nInterceptors = 2;

      final memoInterceptors = MemoInterceptors<dynamic, Args1>([
        FakeInterceptorForCoverage(),
        ...List.generate(
          nInterceptors,
          (_) => MemoInterceptorWrapper<dynamic, Args1>(
            onInit: (memo, args) {
              nCallOnInit += 1;
            },
            onValue: (memo, args, value, fromCache) {
              lastValue = value;
              nCallOnValue += 1;

              if (fromCache) {
                nCallOnValueFromCache += 1;
              }
            },
            onError: (memo, args, error) {
              lastError = error;
              nCallOnError += 1;
            },
            onFinish: (memo, args) {
              nCallOnFinish += 1;
            },
          ),
        ),
      ]);

      final memo = Memo<dynamic, Args1>(
        (Args1 args) {
          if (args.arg1 is Error) throw args.arg1;

          return args.arg1;
        },
        memoInterceptors,
      );

      expect(nCallOnInit, 0 * nInterceptors);
      expect(nCallOnValue, 0 * nInterceptors);
      expect(nCallOnValueFromCache, 0 * nInterceptors);
      expect(nCallOnError, 0 * nInterceptors);
      expect(nCallOnFinish, 0 * nInterceptors);
      expect(lastValue, isNull);
      expect(lastError, isNull);

      memo(Args1('test'));

      expect(nCallOnInit, 1 * nInterceptors);
      expect(nCallOnValue, 1 * nInterceptors);
      expect(nCallOnValueFromCache, 0 * nInterceptors);
      expect(nCallOnError, 0 * nInterceptors);
      expect(nCallOnFinish, 1 * nInterceptors);
      expect(lastValue, 'test');
      expect(lastError, isNull);

      memo(Args1('test'));

      expect(nCallOnInit, 2 * nInterceptors);
      expect(nCallOnValue, 2 * nInterceptors);
      expect(nCallOnValueFromCache, 1 * nInterceptors);
      expect(nCallOnError, 0 * nInterceptors);
      expect(nCallOnFinish, 2 * nInterceptors);
      expect(lastValue, 'test');
      expect(lastError, isNull);

      memo(Args1('test2'));

      expect(nCallOnInit, 3 * nInterceptors);
      expect(nCallOnValue, 3 * nInterceptors);
      expect(nCallOnValueFromCache, 1 * nInterceptors);
      expect(nCallOnError, 0 * nInterceptors);
      expect(nCallOnFinish, 3 * nInterceptors);
      expect(lastValue, 'test2');
      expect(lastError, isNull);

      try {
        memo(Args1(ArgumentError()));
      } catch (e) {
        expect(e, isArgumentError);
      }

      expect(nCallOnInit, 4 * nInterceptors);
      expect(nCallOnValue, 3 * nInterceptors);
      expect(nCallOnValueFromCache, 1 * nInterceptors);
      expect(nCallOnError, 1 * nInterceptors);
      expect(nCallOnFinish, 4 * nInterceptors);
      expect(lastValue, 'test2');
      expect(lastError, isArgumentError);
    });
  });

  group("Memo.inline", () {
    test("should be a class callable with arguments", () {
      final testController = TestController();

      expect(testController.inlineMemo.call, isA<Function(Args)>());
    });

    test("should memoize the returned value by the calculate function", () {
      final testController = TestController();

      final value0 = testController.inlineMemo(null);
      final value1 = testController.inlineMemo(Args1(1));
      final value2 = testController.inlineMemo(Args2(1, 2));
      final value0Cached = testController.inlineMemo(null);
      final value1Cached = testController.inlineMemo(Args1(1));
      final value2Cached = testController.inlineMemo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, true);
      expect(value1 == value1Cached, true);
      expect(value2 == value2Cached, true);
    });

    test("should override the cached value", () {
      final testController = TestController();

      final value0 = testController.inlineMemo(null);
      final value1 = testController.inlineMemo(Args1(1));
      final value2 = testController.inlineMemo(Args2(1, 2));
      final value0Cached = testController.inlineMemo(null, overrideCache: true);
      final value1Cached =
          testController.inlineMemo(Args1(1), overrideCache: true);
      final value2Cached = testController.inlineMemo(Args2(1, 2));

      expect(value0, isEmpty);
      expect(value1, [1]);
      expect(value2, [1, 2]);
      expect(value0 == value0Cached, false);
      expect(value1 == value1Cached, false);
      expect(value2 == value2Cached, true);
    });
  });
}
