import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("UseAsyncState", () {
    test("should resolve state", () async {
      final testController = Rt.createState(() => TestController());
      final stateAsync = testController.stateAsync;

      expect(stateAsync.value, "initial");

      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");
    });

    test("should catch error", () async {
      final testController = Rt.createState(() => TestController());
      final stateAsync = testController.stateAsyncWithError;

      await stateAsync.resolve();

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.error);
      expect(stateAsync.error.toString(), "Exception: has a error");
    });

    test("should reset state", () async {
      final testController = Rt.createState(() => TestController());
      final stateAsync = testController.stateAsync;

      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");

      stateAsync.reset();

      expect(stateAsync.value, "initial");
    });

    test("should resolve state with arguments", () async {
      final testController = Rt.createState(() => TestController());
      final stateAsync = testController.stateAsyncWithArg;

      await stateAsync.resolve(Args1('arg1'));

      expect(stateAsync.value, "resolved with args: arg1");

      await stateAsync.resolve(Args2('arg1', 'arg2'));

      expect(stateAsync.value, "resolved with args: arg1,arg2");

      await stateAsync.resolve(Args3('arg1', 'arg2', 'arg3'));

      expect(stateAsync.value, "resolved with args: arg1,arg2,arg3");
    });

    test("should get value when", () async {
      final testController = Rt.createState(() => TestController());
      final stateAsync = testController.stateAsyncWithArg;

      final s1 = stateAsync.when<String>(standby: (value) => value);
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

      final s5 = stateAsync.when<String>(standby: (value) => value);
      expect(s5, "initial");
    });
  });
}
