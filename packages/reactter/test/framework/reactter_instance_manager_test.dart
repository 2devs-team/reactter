import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/src/framework.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("ReactterInstanceManager", () {
    test("should register instance", () async {
      bool registered = Reactter.register(builder: () => TestController());
      expect(registered, true);

      registered = Reactter.register(builder: () => TestController());
      expect(registered, false);

      Reactter.unregister<TestController>();
    });

    test("should register instance with id", () async {
      bool registered = Reactter.register(
        id: 'uniqueId',
        builder: () => TestController(),
      );
      expect(registered, true);

      registered = Reactter.register(
        id: 'uniqueId',
        builder: () => TestController(),
      );
      expect(registered, false);

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should unregister instance", () async {
      Reactter.register(builder: () => TestController());

      bool unregistered = Reactter.unregister<TestController>();
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>();
      expect(unregistered, false);
    });

    test("should unregister instance with id", () async {
      Reactter.register(id: 'uniqueId', builder: () => TestController());

      bool unregistered = Reactter.unregister<TestController>('uniqueId');
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>('uniqueId');
      expect(unregistered, false);
    });

    test("should get instance", () async {
      var instance = Reactter.get<TestController>();
      expect(instance, null);

      Reactter.register(builder: () => TestController());

      instance = Reactter.get<TestController>();
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>();
    });

    test("should get instance with id", () async {
      var instance = Reactter.get<TestController>('uniqueId');
      expect(instance, null);

      Reactter.register(id: 'uniqueId', builder: () => TestController());

      instance = Reactter.get<TestController>('uniqueId');
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should create instance", () async {
      var instance =
          Reactter.create(builder: () => TestController(), ref: 'key');

      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>();
    });

    test("should create instance with id", () async {
      final instance = Reactter.create(
          id: 'uniqueId', builder: () => TestController(), ref: 'key');

      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should delete instance", () async {
      Reactter.create(builder: () => TestController(), ref: 'key');

      bool isDeleted = Reactter.delete<TestController>(null, 'key');
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestController>(null, 'key');
      expect(isDeleted, false);

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should create instance with id", () async {
      final instance = Reactter.create(
          id: 'uniqueId', builder: () => TestController(), ref: 'key');

      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should delete instance with id", () async {
      Reactter.create(
          id: 'uniqueId', builder: () => TestController(), ref: 'key');

      bool isDeleted = Reactter.delete<TestController>('uniqueId', 'key');
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestController>('uniqueId', 'key');
      expect(isDeleted, false);

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should find instance", () async {
      var reactterInstance = Reactter.find(TestController());
      expect(reactterInstance, null);

      final instance = Reactter.create(builder: () => TestController());

      reactterInstance = Reactter.find(instance);
      expect(reactterInstance, isA<ReactterInstance>());

      Reactter.unregister<TestController>();
    });

    test("should get the instance", () async {
      var instance = Reactter.instanceOf<TestController>();
      expect(instance, null);

      Reactter.create(builder: () => TestController());
      instance = Reactter.instanceOf<TestController>();
      expect(instance, isA<TestController>());
      Reactter.unregister<TestController>();
    });

    test("should get the instance with id", () async {
      var instance = Reactter.instanceOf<TestController>('uniqueId');
      expect(instance, null);

      Reactter.create(id: 'uniqueId', builder: () => TestController());
      instance = Reactter.instanceOf<TestController>('uniqueId');
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>('uniqueId');
    });

    test("should check if exist the instance", () async {
      bool isExistInstance = Reactter.exists<TestController>();
      expect(isExistInstance, false);

      Reactter.create(builder: () => TestController());
      isExistInstance = Reactter.exists<TestController>();
      expect(isExistInstance, true);
    });

    test("should check if exist the instance with id", () async {
      bool isExistInstance = Reactter.exists<TestController>('uniqueId');
      expect(isExistInstance, false);

      Reactter.create(id: 'uniqueId', builder: () => TestController());
      isExistInstance = Reactter.exists<TestController>('uniqueId');
      expect(isExistInstance, true);
    });
  });
}
