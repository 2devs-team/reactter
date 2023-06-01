import 'package:test/test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

const ID = 'uniqueId';

void main() {
  group("UseContext", () {
    test("should gets instance", () => _testController());

    test("should gets instance by id", () => _testController(ID));

    test("should gets instance late", () => _testControllerLate());

    test("should gets instance by id late", () => _testControllerLate(ID));
  });
}

void _testController([String? id]) {
  Reactter.create(id: id, builder: () => TestController());

  final testController = UseContext<TestController>(id);

  expect(testController.instance, isA<TestController>());

  Reactter
    ..unregister<TestController>(id)
    ..delete<TestController>(id);
}

void _testControllerLate([String? id]) {
  late final TestController instance;
  final testController = UseContext<TestController>(id);

  UseEffect(() {
    if (testController.instance != null) {
      instance = testController.instance!;
    }
  }, [testController]);

  Reactter.create(id: id, builder: () => TestController());
  Reactter
    ..unregister<TestController>(id)
    ..delete<TestController>(id);

  expectLater(instance, isA<TestController>());
}
