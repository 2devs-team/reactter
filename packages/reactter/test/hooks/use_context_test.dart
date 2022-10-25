import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_context.dart';

const ID = 'uniqueId';

void main() {
  group("UseContext", () {
    test("should gets instance", () => _testContext());

    test("should gets instance by id", () => _testContext(ID));

    test("should gets instance late", () async {
      await _testContextLate();
    });

    test(
      "should gets instance by id late",
      () async => _testContextLate(ID),
    );
  });
}

void _testContext([String? id]) {
  final context = Reactter.create(id: id, builder: () => TestContext());

  final testContext = UseContext<TestContext>(id: id, context: context);

  expect(testContext.instance, isInstanceOf<TestContext>());

  Reactter
    ..unregister<TestContext>(id)
    ..delete<TestContext>(id);
  testContext.dispose();
}

Future<void> _testContextLate([String? id]) async {
  late final TestContext instance;
  final testContext = UseContext<TestContext>(id: id);

  UseEffect(() {
    if (testContext.instance != null) {
      instance = testContext.instance!;
    }
  }, [testContext]);

  Reactter.create(id: id, builder: () => TestContext());
  Reactter
    ..unregister<TestContext>(id)
    ..delete<TestContext>(id);
  testContext.dispose();

  expectLater(instance, isInstanceOf<TestContext>());
}
