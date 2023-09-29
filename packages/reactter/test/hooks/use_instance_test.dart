import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

const ID = 'uniqueId';

void main() {
  group("UseInstance", () {
    test("should get instance", () => _testController());

    test("should get instance by id", () => _testController(ID));

    test("should get instance late", () => _testControllerLate());

    test("should get instance by id late", () => _testControllerLate(ID));
  });
}

void _testController([String? id]) {
  Reactter.create(id: id, builder: () => TestController());

  final testController = UseInstance<TestController>(id);

  expect(testController.instance, isA<TestController>());

  Reactter
    ..unregister<TestController>(id)
    ..delete<TestController>(id);
}

void _testControllerLate([String? id]) {
  late final TestController instance;
  final testController = UseInstance<TestController>(id);

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
