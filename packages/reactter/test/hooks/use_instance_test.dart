// ignore_for_file: constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

import '../shareds/test_controllers.dart';

const ID = 'uniqueId';

void main() {
  group("UseInstance", () {
    test("should get an instance", () => _testController());

    test("should get an instance with id", () => _testController(ID));

    test("should get an instance late", () => _testControllerLate());

    test("should get an instance with id late", () => _testControllerLate(ID));

    test("should register an instance", () {
      final useInstance = UseInstance.register(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.destroy<TestController>();
    });

    test("should register an instance with id", () {
      final useInstance = UseInstance.register(() => TestController(), id: ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should register an instance in builder mode", () {
      final useInstance = UseInstance.lazyBuilder(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.builder);

      Reactter.destroy<TestController>();
    });

    test("should register an instance with id in builder mode", () {
      final useInstance = UseInstance.lazyBuilder(() => TestController(), ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.builder);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should register an instance in factory mode", () {
      final useInstance = UseInstance.lazyFactory(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.factory);

      Reactter.destroy<TestController>();
    });

    test("should register an instance with id in factory mode", () {
      final useInstance = UseInstance.lazyFactory(() => TestController(), ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.factory);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should register an instance in singleton mode", () {
      final useInstance = UseInstance.lazySingleton(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.singleton);

      Reactter.destroy<TestController>();
    });

    test("should register an instance with id in singleton mode", () {
      final useInstance = UseInstance.lazySingleton(() => TestController(), ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.singleton);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should create an instance", () {
      final useInstance = UseInstance.create(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.destroy<TestController>();
    });

    test("should create an instance in builder mode", () {
      final useInstance = UseInstance.builder(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.builder);

      Reactter.destroy<TestController>();
    });

    test("should create an instance with id in builder mode", () {
      final useInstance = UseInstance.builder(() => TestController(), ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.builder);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should create an instance in factory mode", () {
      final useInstance = UseInstance.factory(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.factory);

      Reactter.destroy<TestController>();
    });

    test("should create an instance with id in factory mode", () {
      final useInstance = UseInstance.factory(() => TestController(), ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.factory);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should create an instance in singleton mode", () {
      final useInstance = UseInstance.singleton(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.singleton);

      Reactter.destroy<TestController>();
    });

    test("should create an instance with id in singleton mode", () {
      final useInstance = UseInstance.singleton(() => TestController(), ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceManageMode =
          Reactter.getInstanceManageMode(useInstance.instance);
      expect(instanceManageMode, InstanceManageMode.singleton);

      Reactter.destroy<TestController>(id: ID);
    });

    test("should get an instance", () {
      Reactter.register(() => TestController());

      final useInstance = UseInstance<TestController>.get();
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.destroy<TestController>();
    });

    test("should get an instance with id", () {
      Reactter.register(() => TestController(), id: ID);

      final useInstance = UseInstance<TestController>.get(ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.destroy<TestController>(id: ID);
    });
  });
}

void _testController([String? id]) {
  Reactter.create(() => TestController(), id: id);

  final useInstance = UseInstance<TestController>(id);

  expect(useInstance.instance, isA<TestController>());

  Reactter.destroy<TestController>(id: id);
}

void _testControllerLate([String? id]) {
  late final TestController instance;
  final useInstance = UseInstance<TestController>(id);

  UseEffect(() {
    if (useInstance.instance != null) {
      instance = useInstance.instance!;
    }
  }, [useInstance]);

  Reactter.create(() => TestController(), id: id);
  Reactter.destroy<TestController>(id: id);

  expectLater(instance, isA<TestController>());
}
