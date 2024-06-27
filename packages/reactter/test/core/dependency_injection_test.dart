import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("DependencyInjection", () {
    test("should register a dependency", () {
      bool registered = Reactter.register(() => TestController());
      expect(registered, true);

      registered = Reactter.register(() => TestController());
      expect(registered, false);

      Reactter.destroy<TestController>();
    });

    test("should register a dependency with id", () {
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

      Reactter.destroy<TestController>(id: id);
    });

    test("should unregister a dependency", () {
      Reactter.register(() => TestController());

      bool unregistered = Reactter.unregister<TestController>();
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>();
      expect(unregistered, false);

      Reactter.create(() => TestController());

      unregistered = Reactter.unregister<TestController>();
      expect(unregistered, false);

      Reactter.destroy<TestController>(onlyInstance: true);

      unregistered = Reactter.unregister<TestController>();
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>();
      expect(unregistered, false);
    });

    test("should unregister a dependency with id", () {
      final id = 'uniqueId';

      Reactter.register(() => TestController(), id: id);

      bool unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, false);

      Reactter.create(() => TestController(), id: id);

      unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, false);

      Reactter.destroy<TestController>(id: id, onlyInstance: true);

      unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, true);

      unregistered = Reactter.unregister<TestController>(id);
      expect(unregistered, false);
    });

    test("should get a dependency", () {
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

      Reactter.destroy<TestController>();
    });

    test("should get a dependency with id", () {
      final id = 'uniqueId';

      var instance = Reactter.get<TestController>(id);
      expect(instance, null);

      Reactter.register(() => TestController(), id: id);

      instance = Reactter.get<TestController>(id);
      expect(instance, isA<TestController>());

      Reactter.destroy<TestController>(id: id);
    });

    test("should create a dependency", () {
      final ref = #ref;

      final instance = Reactter.create(() => TestController(), ref: ref);
      expect(instance, isA<TestController>());

      Reactter.destroy<TestController>();
    });

    test("should create a dependency with id", () {
      final id = 'uniqueId';
      final ref = #ref;

      final instance = Reactter.create(
        () => TestController(),
        id: id,
        ref: ref,
      );

      expect(instance, isA<TestController>());

      Reactter.destroy<TestController>(id: id);
    });

    test("should delete a dependency", () {
      final ref = #ref;

      Reactter.create(() => TestController(), ref: ref);

      bool isDeleted = Reactter.delete<TestController>(null, ref);
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestController>(null, ref);
      expect(isDeleted, false);

      Reactter.destroy<TestController>();
    });

    test("should delete a dependency with id", () {
      final ref = #ref;
      final id = 'uniqueId';

      Reactter.create(() => TestController(), id: id, ref: ref);

      bool isDeleted = Reactter.delete<TestController>(id, ref);
      expect(isDeleted, true);

      isDeleted = Reactter.delete<TestController>(id, ref);
      expect(isDeleted, false);

      Reactter.destroy<TestController>(id: id);
    });

    test("should destroy a dependency", () {
      var isDestroyed = Reactter.destroy<TestController>();
      expect(isDestroyed, false);

      isDestroyed = Reactter.destroy<TestController>(onlyInstance: true);
      expect(isDestroyed, false);

      Reactter.create(() => TestController());

      isDestroyed = Reactter.destroy<TestController>(onlyInstance: true);
      expect(isDestroyed, true);

      final instance = Reactter.find<TestController>();
      expect(instance, null);

      Reactter.get<TestController>();

      isDestroyed = Reactter.destroy<TestController>();
      expect(isDestroyed, true);
    });

    test("should destroy a dependency with id", () {
      final id = 'UniqueId';

      var isDestroyed = Reactter.destroy<TestController>(id: id);
      expect(isDestroyed, false);

      isDestroyed = Reactter.destroy<TestController>(
        id: id,
        onlyInstance: true,
      );
      expect(isDestroyed, false);

      Reactter.create(() => TestController(), id: id);

      isDestroyed = Reactter.destroy<TestController>(
        id: id,
        onlyInstance: true,
      );
      expect(isDestroyed, true);

      final instance = Reactter.find<TestController>(id);
      expect(instance, null);

      Reactter.get<TestController>(id);

      isDestroyed = Reactter.destroy<TestController>(id: id);
      expect(isDestroyed, true);
    });

    test("should find a dependency", () {
      var instance = Reactter.find<TestController>();
      expect(instance, null);

      Reactter.create(() => TestController());

      instance = Reactter.find<TestController>();
      expect(instance, isA<TestController>());

      Reactter.destroy<TestController>();
    });

    test("should find a dependency with id", () {
      final id = 'uniqueId';
      var instance = Reactter.find<TestController>(id);
      expect(instance, null);

      Reactter.create(() => TestController(), id: id);
      instance = Reactter.find<TestController>(id);
      expect(instance, isA<TestController>());

      Reactter.destroy<TestController>(id: id);
    });

    test("should check if a dependency is registered", () {
      final testController = TestController();
      bool isRegisted = Reactter.isRegistered(testController);
      expect(isRegisted, false);

      final instance = Reactter.create(() => testController);
      expect(instance, testController);

      isRegisted = Reactter.isRegistered(testController);
      expect(isRegisted, true);

      Reactter.destroy<TestController>();
    });

    test("should check if exist a dependency", () {
      bool isExistInstance = Reactter.exists<TestController>();
      expect(isExistInstance, false);

      Reactter.create(() => TestController());
      isExistInstance = Reactter.exists<TestController>();
      expect(isExistInstance, true);

      Reactter.destroy<TestController>();
    });

    test("should check if exist a dependency with id", () {
      final id = 'uniqueId';

      bool isExistInstance = Reactter.exists<TestController>(id);
      expect(isExistInstance, false);

      Reactter.create(() => TestController(), id: id);
      isExistInstance = Reactter.exists<TestController>(id);
      expect(isExistInstance, true);

      Reactter.destroy<TestController>(id: id);
    });

    test("should create a dependency in builder mode", () {
      final instance = Reactter.builder(() => TestController());
      expect(instance, isA<TestController>());

      final dependencyMode = Reactter.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.builder);

      final isDeleted = Reactter.delete<TestController>();
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>();
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyBuilder(() => TestController());
      expect(isRegistered, true);

      Reactter.destroy<TestController>();
    });

    test("should create a dependency with id in builder mode", () {
      final id = 'uniqueId';

      final instance = Reactter.builder(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final dependencyMode = Reactter.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.builder);

      final isDeleted = Reactter.delete<TestController>(id);
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>(id);
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyBuilder(() => TestController(), id: id);
      expect(isRegistered, true);

      Reactter.destroy<TestController>(id: id);
    });

    test("should create a dependency in factory mode", () {
      final instance = Reactter.factory(() => TestController());
      expect(instance, isA<TestController>());

      final dependencyMode = Reactter.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.factory);

      final isDeleted = Reactter.delete<TestController>();
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>();
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyFactory(() => TestController());
      expect(isRegistered, false);

      Reactter.destroy<TestController>();
    });

    test("should create a dependency with id in factory mode", () {
      final id = 'uniqueId';

      final instance = Reactter.factory(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final dependencyMode = Reactter.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.factory);

      final isDeleted = Reactter.delete<TestController>(id);
      expect(isDeleted, true);

      final instanceBeforeDeleted = Reactter.find<TestController>(id);
      expect(instanceBeforeDeleted, null);

      final isRegistered = Reactter.lazyFactory(() => TestController(), id: id);
      expect(isRegistered, false);

      Reactter.destroy<TestController>(id: id);
    });

    test("should create a dependency in singleton mode", () {
      final instance = Reactter.singleton(() => TestController());
      expect(instance, isA<TestController>());

      final dependencyMode = Reactter.getDependencyMode(instance);
      expect(dependencyMode, DependencyMode.singleton);

      final isDeleted = Reactter.delete<TestController>();
      expect(isDeleted, false);

      final instanceBeforeDeleted = Reactter.find<TestController>();
      expect(instanceBeforeDeleted, isA<TestController>());
      expect(instanceBeforeDeleted, instance);

      final isRegistered = Reactter.lazySingleton(() => TestController());
      expect(isRegistered, false);

      Reactter.destroy<TestController>();
    });

    test("should create a dependency with id in singleton mode", () {
      final id = 'uniqueId';

      final instance = Reactter.singleton(() => TestController(), id: id);
      expect(instance, isA<TestController>());

      final nstanceManageMode = Reactter.getDependencyMode(instance);
      expect(nstanceManageMode, DependencyMode.singleton);

      final isDeleted = Reactter.delete<TestController>(id);
      expect(isDeleted, false);

      final instanceBeforeDeleted = Reactter.find<TestController>(id);
      expect(instanceBeforeDeleted, isA<TestController>());
      expect(instanceBeforeDeleted, instance);

      final isRegistered =
          Reactter.lazySingleton(() => TestController(), id: id);
      expect(isRegistered, false);

      Reactter.destroy<TestController>(id: id);
    });

    test("should get hashcode ref by index", () {
      final ref = 'myRef';

      Reactter.create(() => TestController(), ref: ref);

      final hashCodeRef = Reactter.getHashCodeRefAt<TestController>(0);
      expect(hashCodeRef, isA<int>());
      expect(hashCodeRef, ref.hashCode);

      Reactter.destroy<TestController>();
    });
  });
}
