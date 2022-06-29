import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import 'shareds/test_context.dart';

void main() {
  group("UseAsyncState", () {
    test("should resolved state", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      expect(stateAsync.value, "initial");

      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");
    });

    test("should catch error", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      await stateAsync.resolve(true);

      expect(stateAsync.value, "initial");
      expect(stateAsync.status, UseAsyncStateStatus.error);
      expect(stateAsync.error.toString(), "Exception: has a error");
    });

    test("should reset state", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      await stateAsync.resolve();

      expect(stateAsync.value, "resolved");

      stateAsync.reset();

      expect(stateAsync.value, "initial");
    });

    test("should get value when", () async {
      final testContext = TestContext();
      final stateAsync = testContext.stateAsync;

      final s1 = stateAsync.when<String>(standby: (value) => value);
      expect(s1, "initial");

      stateAsync.resolve();

      final s2 = stateAsync.when<String>(loading: (value) => "loading");
      expect(s2, "loading");

      await stateAsync.resolve();

      final s3 = stateAsync.when<String>(done: (value) => value);
      expect(s3, "resolved");

      await stateAsync.resolve(true);

      final s4 = stateAsync.when<String>(error: (error) => error.toString());
      expect(s4, "Exception: has a error");

      stateAsync.reset();

      final s5 = stateAsync.when<String>(standby: (value) => value);
      expect(s5, "initial");
    });
  });
}
