import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/src/framework.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("ReactterInstanceManager", () {
    test("should register instance", () {
      bool registered = Reactter.register(() => TestController());
      expect(registered, true);

      registered = Reactter.register(() => TestController());
      expect(registered, false);

      Reactter.unregister<TestController>();
    });

    test("should register instance with id", () {
      final id = 'uniqueId';

      bool registered = Reactter.register(
        () => TestController(),
        id: id,
      );
      expect(registered, true);

      registered = Reactter.register(
        () => TestController(),
        id: id,
      );
      expect(registered, false);

      Reactter.unregister<TestController>(id);
    });

    test("should unregister instance", () {
      Reactter.register(() => TestController());

      bool unregistered = Reactter.unregister<TestController>();
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>();
      expect(unregistered, false);
    });

    test("should unregister instance with id", () {
      final id = 'uniqueId';

      Reactter.register(() => TestController(), id: id);

      bool unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, false);
    });

    test("should get instance", () {
      var instance = Reactter.get<TestController>();
      expect(instance, null);

      Reactter.register(() => TestController());
      Reactter.register<Test2Controller?>(() => null);

      instance = Reactter.get<TestController>();
      expect(instance, isA<TestController>());

      instance = Reactter.get<TestController?>();
      expect(instance, isA<TestController>());

      final instance2 = Reactter.get<Test2Controller>();
      expect(instance2, null);

      Reactter.unregister<TestController>();
    });

    test("should get instance with id", () {
      final id = 'uniqueId';

      var instance = Reactter.get<TestController>(id);
      expect(instance, null);

      Reactter.register(() => TestController(), id: id);

      instance = Reactter.get<TestController>(id);
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>(id);
    });

    test("should create instance", () {
      final ref = #ref;

      final instance = Reactter.create(() => TestController(), ref: ref);
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>();
    });

    test("should create instance with id", () {
      final id = 'uniqueId';
      final ref = #ref;

      final instance = Reactter.create(
        () => TestController(),
        id: id,
        ref: ref,
      );

      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>(id);
    });

    test("should delete instance", () {
      final ref = #ref;

      Reactter.create(() => TestController(), ref: ref);

      bool isDeleted = Reactter.delete<TestController>(null, ref);
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestController>(null, ref);
      expect(isDeleted, false);

      Reactter.unregister<TestController>();
    });

    test("should create instance with id", () {
      final id = 'uniqueId';
      final ref = #ref;

      final instance = Reactter.create(
        () => TestController(),
        id: id,
        ref: ref,
      );

      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>(id);
    });

    test("should delete instance with id", () {
      final id = 'uniqueId';
      final ref = #ref;

      Reactter.create(() => TestController(), id: id, ref: ref);

      bool isDeleted = Reactter.delete<TestController>(id, ref);
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestController>(id, ref);
      expect(isDeleted, false);

      Reactter.unregister<TestController>(id);
    });

    test("should find the instance", () {
      var instance = Reactter.find<TestController>();
      expect(instance, null);

      Reactter.create(() => TestController());

      instance = Reactter.find<TestController>();
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>();
    });

    test("should find the instance with id", () {
      final id = 'uniqueId';
      var instance = Reactter.find<TestController>(id);
      expect(instance, null);

      Reactter.create(() => TestController(), id: id);
      instance = Reactter.find<TestController>(id);
      expect(instance, isA<TestController>());

      Reactter.unregister<TestController>(id);
    });

    test("should check if a instance is registered", () {
      final testController = TestController();
      bool isRegisted = Reactter.isRegistered(testController);
      expect(isRegisted, false);

      final instance = Reactter.create(() => testController);
      expect(instance, testController);

      isRegisted = Reactter.isRegistered(testController);
      expect(isRegisted, true);

      Reactter.unregister<TestController>();
    });

    test("should check if exist the instance", () {
      bool isExistInstance = Reactter.exists<TestController>();
      expect(isExistInstance, false);

      Reactter.create(() => TestController());
      isExistInstance = Reactter.exists<TestController>();
      expect(isExistInstance, true);

      Reactter.unregister<TestController>();
    });

    test("should check if exist the instance with id", () {
      final id = 'uniqueId';

      bool isExistInstance = Reactter.exists<TestController>(id);
      expect(isExistInstance, false);

      Reactter.create(() => TestController(), id: id);
      isExistInstance = Reactter.exists<TestController>(id);
      expect(isExistInstance, true);

      Reactter.unregister<TestController>(id);
    });

    test("should create the instance as builder type", () {
      final instance = Reactter.builder(() => TestController());
      expect(instance, isA<TestController>());

      final instanceType = Reactter.getInstanceType(instance);
      expect(instanceType, InstanceType.builder);

      final isDeleted = Reactter.delete<TestController>();
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>();
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyBuilder(() => TestController());
      expect(isRegistered, true);

      Reactter.unregister<TestController>();
    });

    test("should create the instance with id as builder type", () {
      final id = 'uniqueId';

      final instance = Reactter.builder(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final instanceType = Reactter.getInstanceType(instance);
      expect(instanceType, InstanceType.builder);

      final isDeleted = Reactter.delete<TestController>(id);
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>(id);
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyBuilder(() => TestController(), id: id);
      expect(isRegistered, true);

      Reactter.unregister<TestController>(id);
    });

    test("should create the instance as factory type", () {
      final instance = Reactter.factory(() => TestController());
      expect(instance, isA<TestController>());

      final instanceType = Reactter.getInstanceType(instance);
      expect(instanceType, InstanceType.factory);

      final isDeleted = Reactter.delete<TestController>();
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>();
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyFactory(() => TestController());
      expect(isRegistered, false);

      Reactter.unregister<TestController>();
    });

    test("should create the instance with id as factory type", () {
      final id = 'uniqueId';

      final instance = Reactter.factory(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final instanceType = Reactter.getInstanceType(instance);
      expect(instanceType, InstanceType.factory);

      final isDeleted = Reactter.delete<TestController>(id);
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>(id);
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyFactory(() => TestController(), id: id);
      expect(isRegistered, false);

      Reactter.unregister<TestController>(id);
    });

    test("should create the instance as singleton type", () {
      final instance = Reactter.singleton(() => TestController());
      expect(instance, isA<TestController>());

      final instanceType = Reactter.getInstanceType(instance);
      expect(instanceType, InstanceType.singleton);

      final isDeleted = Reactter.delete<TestController>();
      expect(isDeleted, false);

      final instanceBeforeDeleted = Reactter.find<TestController>();
      expect(instanceBeforeDeleted, isA<TestController>());
      expect(instanceBeforeDeleted, instance);

      final isRegistered = Reactter.lazySingleton(() => TestController());
      expect(isRegistered, false);

      Reactter.unregister<TestController>();
    });

    test("should create the instance with id as singleton type", () {
      final id = 'uniqueId';

      final instance = Reactter.singleton(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final instanceType = Reactter.getInstanceType(instance);
      expect(instanceType, InstanceType.singleton);

      final isDeleted = Reactter.delete<TestController>(id);
      expect(isDeleted, false);

      final instanceBeforeDeleted = Reactter.find<TestController>(id);
      expect(instanceBeforeDeleted, isA<TestController>());
      expect(instanceBeforeDeleted, instance);

      final isRegistered =
          Reactter.lazySingleton(() => TestController(), id: id);
      expect(isRegistered, false);

      Reactter.unregister<TestController>(id);
    });
  });
}
