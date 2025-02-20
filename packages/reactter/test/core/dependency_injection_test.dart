import 'package:reactter/reactter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../shareds/test_controllers.dart';

class MyTest {
  final uState = UseState(0);
}

void main() {
  group("DependencyInjection", () {
    test("should register a dependency", () {
      bool registered = Rt.register(() => TestController());
      expect(registered, true);

      registered = Rt.register(() => TestController());
      expect(registered, false);

      Rt.destroy<TestController>();
    });

    test("should register a dependency with id", () {
      final id = 'uniqueId';

      bool registered = Rt.register(
        () => TestController(),
        id: id,
      );
      expect(registered, true);

      registered = Rt.register(
        () => TestController(),
        id: id,
      );
      expect(registered, false);

      Rt.destroy<TestController>(id: id);
    });

    test("should unregister a dependency", () {
      Rt.register(() => TestController());

      bool unregistered = Rt.unregister<TestController>();
      expect(unregistered, true);

      unregistered = Rt.unregister<TestController>();
      expect(unregistered, false);

      Rt.create(() => TestController());

      unregistered = Rt.unregister<TestController>();
      expect(unregistered, false);

      Rt.destroy<TestController>(onlyInstance: true);

      unregistered = Rt.unregister<TestController>();
      expect(unregistered, true);

      unregistered = Rt.unregister<TestController>();
      expect(unregistered, false);
    });

    test("should unregister a dependency with id", () {
      final id = 'uniqueId';

      Rt.register(() => TestController(), id: id);

      bool unregistered = Rt.unregister<TestController>(id);
      expect(unregistered, true);

      unregistered = Rt.unregister<TestController>(id);
      expect(unregistered, false);

      Rt.create(() => TestController(), id: id);

      unregistered = Rt.unregister<TestController>(id);
      expect(unregistered, false);

      Rt.destroy<TestController>(id: id, onlyInstance: true);

      unregistered = Rt.unregister<TestController>(id);
      expect(unregistered, true);

      unregistered = Rt.unregister<TestController>(id);
      expect(unregistered, false);
    });

    test("should get a dependency", () {
      var instance = Rt.get<TestController>();
      expect(instance, null);

      Rt.register(() => TestController());
      Rt.register<Test2Controller?>(() => null);

      instance = Rt.get<TestController>();
      expect(instance, isA<TestController>());

      instance = Rt.get<TestController?>();
      expect(instance, isA<TestController>());

      final instance2 = Rt.get<Test2Controller>();
      expect(instance2, null);

      Rt.destroy<TestController>();
    });

    test("should get a dependency with id", () {
      final id = 'uniqueId';

      var instance = Rt.get<TestController>(id);
      expect(instance, null);

      Rt.register(() => TestController(), id: id);

      instance = Rt.get<TestController>(id);
      expect(instance, isA<TestController>());

      Rt.destroy<TestController>(id: id);
    });

    test("should create a dependency", () {
      final ref = #ref;

      final instance = Rt.create(() => TestController(), ref: ref);
      expect(instance, isA<TestController>());

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id", () {
      final id = 'uniqueId';
      final ref = #ref;

      final instance = Rt.create(
        () => TestController(),
        id: id,
        ref: ref,
      );

      expect(instance, isA<TestController>());

      Rt.destroy<TestController>(id: id);
    });

    test("should delete a dependency", () {
      final ref = #ref;

      Rt.create(() => TestController(), ref: ref);

      bool isDeleted = Rt.delete<TestController>(null, ref);
      expect(isDeleted, true);

      isDeleted = Rt.delete<TestController>(null, ref);
      expect(isDeleted, false);

      Rt.destroy<TestController>();
    });

    test("should delete a dependency with id", () {
      final ref = #ref;
      final id = 'uniqueId';

      Rt.create(() => TestController(), id: id, ref: ref);

      bool isDeleted = Rt.delete<TestController>(id, ref);
      expect(isDeleted, true);

      isDeleted = Rt.delete<TestController>(id, ref);
      expect(isDeleted, false);

      Rt.destroy<TestController>(id: id);
    });

    test("should destroy a dependency", () {
      var isDestroyed = Rt.destroy<TestController>();
      expect(isDestroyed, false);

      isDestroyed = Rt.destroy<TestController>(onlyInstance: true);
      expect(isDestroyed, false);

      Rt.create(() => TestController());

      isDestroyed = Rt.destroy<TestController>(onlyInstance: true);
      expect(isDestroyed, true);

      final instance = Rt.find<TestController>();
      expect(instance, null);

      Rt.get<TestController>();

      isDestroyed = Rt.destroy<TestController>();
      expect(isDestroyed, true);
    });

    test("should destroy a dependency with id", () {
      final id = 'UniqueId';

      var isDestroyed = Rt.destroy<TestController>(id: id);
      expect(isDestroyed, false);

      isDestroyed = Rt.destroy<TestController>(
        id: id,
        onlyInstance: true,
      );
      expect(isDestroyed, false);

      Rt.create(() => TestController(), id: id);

      isDestroyed = Rt.destroy<TestController>(
        id: id,
        onlyInstance: true,
      );
      expect(isDestroyed, true);

      final instance = Rt.find<TestController>(id);
      expect(instance, null);

      Rt.get<TestController>(id);

      isDestroyed = Rt.destroy<TestController>(id: id);
      expect(isDestroyed, true);
    });

    test("should find a dependency", () {
      var instance = Rt.find<TestController>();
      expect(instance, null);

      Rt.create(() => TestController());

      instance = Rt.find<TestController>();
      expect(instance, isA<TestController>());

      Rt.destroy<TestController>();
    });

    test("should find a dependency with id", () {
      final id = 'uniqueId';
      var instance = Rt.find<TestController>(id);
      expect(instance, null);

      Rt.create(() => TestController(), id: id);
      instance = Rt.find<TestController>(id);
      expect(instance, isA<TestController>());

      Rt.destroy<TestController>(id: id);
    });

    test("should check if an instance is registered", () {
      final testController = TestController();
      bool isActive = Rt.isActive(testController);
      expect(isActive, false);

      final instance = Rt.create(() => testController);
      expect(instance, testController);

      isActive = Rt.isActive(testController);
      expect(isActive, true);

      Rt.destroy<TestController>();
    });

    test("should check if a dependency is registered", () {
      final testController = TestController();
      bool hasRegister = Rt.hasRegister<TestController>();
      expect(hasRegister, false);

      final instance = Rt.create(() => testController);
      expect(instance, testController);

      hasRegister = Rt.hasRegister<TestController>();
      expect(hasRegister, true);

      Rt.destroy<TestController>();
    });

    test("should check if exist a dependency", () {
      bool isExistInstance = Rt.exists<TestController>();
      expect(isExistInstance, false);

      Rt.create(() => TestController());
      isExistInstance = Rt.exists<TestController>();
      expect(isExistInstance, true);

      Rt.destroy<TestController>();
    });

    test("should check if exist a dependency with id", () {
      final id = 'uniqueId';

      bool isExistInstance = Rt.exists<TestController>(id);
      expect(isExistInstance, false);

      Rt.create(() => TestController(), id: id);
      isExistInstance = Rt.exists<TestController>(id);
      expect(isExistInstance, true);

      Rt.destroy<TestController>(id: id);
    });

    test("should create a dependency in builder mode", () {
      final instance = Rt.builder(() => TestController());
      expect(instance, isA<TestController>());

      final dependencyMode = Rt.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.builder);

      final isDeleted = Rt.delete<TestController>();
      expect(isDeleted, true);

      final instanceBeforeDeleted = Rt.find<TestController>();
      expect(instanceBeforeDeleted, null);

      final isRegistered = Rt.lazyBuilder(() => TestController());
      expect(isRegistered, true);

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id in builder mode", () {
      final id = 'uniqueId';

      final instance = Rt.builder(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final dependencyMode = Rt.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.builder);

      final isDeleted = Rt.delete<TestController>(id);
      expect(isDeleted, true);

      final instanceBeforeDeleted = Rt.find<TestController>(id);
      expect(instanceBeforeDeleted, null);

      final isRegistered = Rt.lazyBuilder(() => TestController(), id: id);
      expect(isRegistered, true);

      Rt.destroy<TestController>(id: id);
    });

    test("should create a dependency in factory mode", () {
      final instance = Rt.factory(() => TestController());
      expect(instance, isA<TestController>());

      final dependencyMode = Rt.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.factory);

      final isDeleted = Rt.delete<TestController>();
      expect(isDeleted, true);

      final instanceBeforeDeleted = Rt.find<TestController>();
      expect(instanceBeforeDeleted, null);

      final isRegistered = Rt.lazyFactory(() => TestController());
      expect(isRegistered, false);

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id in factory mode", () {
      final id = 'uniqueId';

      final instance = Rt.factory(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final dependencyMode = Rt.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.factory);

      final isDeleted = Rt.delete<TestController>(id);
      expect(isDeleted, true);

      final instanceBeforeDeleted = Rt.find<TestController>(id);
      expect(instanceBeforeDeleted, null);

      final isRegistered = Rt.lazyFactory(() => TestController(), id: id);
      expect(isRegistered, false);

      Rt.destroy<TestController>(id: id);
    });

    test("should create a dependency in singleton mode", () {
      final instance = Rt.singleton(() => TestController());
      expect(instance, isA<TestController>());

      final dependencyMode = Rt.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.singleton);

      final isDeleted = Rt.delete<TestController>();
      expect(isDeleted, false);

      final instanceBeforeDeleted = Rt.find<TestController>();
      expect(instanceBeforeDeleted, isA<TestController>());
      expect(instanceBeforeDeleted, instance);

      final isRegistered = Rt.lazySingleton(() => TestController());
      expect(isRegistered, false);

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id in singleton mode", () {
      final id = 'uniqueId';

      final instance = Rt.singleton(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final nstanceManageMode = Rt.getDependencyMode(instance);
      expect(nstanceManageMode, DependencyMode.singleton);

      final isDeleted = Rt.delete<TestController>(id);
      expect(isDeleted, false);

      final instanceBeforeDeleted = Rt.find<TestController>(id);
      expect(instanceBeforeDeleted, isA<TestController>());
      expect(instanceBeforeDeleted, instance);

      final isRegistered = Rt.lazySingleton(() => TestController(), id: id);
      expect(isRegistered, false);

      Rt.destroy<TestController>(id: id);
    });

    test("should get ref by index", () {
      final ref = 'myRef';

      Rt.create(() => TestController(), ref: ref);

      final hashCodeRef = Rt.getRefAt<TestController>(0);
      expect(hashCodeRef, ref);

      Rt.destroy<TestController>();
    });
  });
}
