import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import 'shareds/test_context.dart';

const ID = 'uniqueId';

void main() {
  group("UseContext", () {
    test("should get instance", () => _testContext());

    test("should get instance by id", () => _testContext(ID));

    test("should get instance late", () => _testContextLate());

    test("should get instance by id late", () => _testContextLate(ID));
  });
}

void _testContext([String? id]) {
  Reactter.create(id: id, builder: () => TestContext());

  final testContext = UseContext<TestContext>(id);

  expect(testContext.instance, isInstanceOf<TestContext>());

  Reactter
    ..unregister<TestContext>(id)
    ..delete<TestContext>(id: id);
  testContext.dispose();
}

void _testContextLate([String? id]) {
  late final TestContext instance;
  final testContext = UseContext<TestContext>(id);

  UseEffect(() {
    if (testContext.instance != null) {
      instance = testContext.instance!;
    }
  }, [testContext]);

  Reactter.create(id: id, builder: () => TestContext());

  expectLater(instance, isInstanceOf<TestContext>());

  Reactter
    ..unregister<TestContext>(id)
    ..delete<TestContext>(id: id);
  testContext.dispose();
}
