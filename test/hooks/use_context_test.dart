// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';

void main() {
  group("UseContext", () {
    test("should create a instance", () {
      final useContext = UseContext(() => TestContext(), init: true);

      expect(useContext, isInstanceOf<UseContext<TestContext>>());
      expect(useContext.instance, isInstanceOf<TestContext>());
    });

    test("should access to instance using onInit", () {
      final useContext = UseContext<TestContext>(
        () => TestContext(),
        init: true,
        onInit: (inst) {
          inst.stateBool.value = true;
        },
      );

      expect(useContext.instance?.stateBool.value, true);
    });
  });
}
