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

      Reactter.unregister<TestController>();
    });

    test("should register an instance with id", () {
      final useInstance = UseInstance.register(() => TestController(), id: ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.unregister<TestController>(ID);
    });

    test("should register an instance as builder type", () {
      final useInstance = UseInstance.lazyBuilder(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.builder);

      Reactter.unregister<TestController>();
    });

    test("should register an instance with id as builder type", () {
      final useInstance = UseInstance.lazyBuilder(() => TestController(), ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.builder);

      Reactter.unregister<TestController>(ID);
    });

    test("should register an instance as factory type", () {
      final useInstance = UseInstance.lazyFactory(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.factory);

      Reactter.unregister<TestController>();
    });

    test("should register an instance with id as factory type", () {
      final useInstance = UseInstance.lazyFactory(() => TestController(), ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.factory);

      Reactter.unregister<TestController>(ID);
    });

    test("should register an instance as singleton type", () {
      final useInstance = UseInstance.lazySingleton(() => TestController());
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>();
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.singleton);

      Reactter.unregister<TestController>();
    });

    test("should register an instance with id as singleton type", () {
      final useInstance = UseInstance.lazySingleton(() => TestController(), ID);
      expect(useInstance.instance, null);

      final instance = Reactter.get<TestController>(ID);
      expect(useInstance.instance, instance);

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.singleton);

      Reactter.unregister<TestController>(ID);
    });

    test("should create an instance", () {
      final useInstance = UseInstance.create(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.unregister<TestController>();
    });

    test("should create an instance as builder type", () {
      final useInstance = UseInstance.builder(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.builder);

      Reactter.unregister<TestController>();
    });

    test("should create an instance with id as builder type", () {
      final useInstance = UseInstance.builder(() => TestController(), ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.builder);

      Reactter.unregister<TestController>(ID);
    });

    test("should create an instance as factory type", () {
      final useInstance = UseInstance.factory(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.factory);

      Reactter.unregister<TestController>();
    });

    test("should create an instance with id as factory type", () {
      final useInstance = UseInstance.factory(() => TestController(), ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.factory);

      Reactter.unregister<TestController>(ID);
    });

    test("should create an instance as singleton type", () {
      final useInstance = UseInstance.singleton(() => TestController());
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.singleton);

      Reactter.unregister<TestController>();
    });

    test("should create an instance with id as singleton type", () {
      final useInstance = UseInstance.singleton(() => TestController(), ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      final instanceType = Reactter.getInstanceType(useInstance.instance);
      expect(instanceType, InstanceType.singleton);

      Reactter.unregister<TestController>(ID);
    });

    test("should get an instance", () {
      Reactter.register(() => TestController());

      final useInstance = UseInstance<TestController>.get();
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.unregister<TestController>();
    });

    test("should get an instance with id", () {
      Reactter.register(() => TestController(), id: ID);

      final useInstance = UseInstance<TestController>.get(ID);
      expect(useInstance.instance, isA<TestController>());

      final isRegistered = Reactter.isRegistered(useInstance.instance);
      expect(isRegistered, true);

      Reactter.unregister<TestController>(ID);
    });
  });
}

void _testController([String? id]) {
  Reactter.create(() => TestController(), id: id);

  final useInstance = UseInstance<TestController>(id);

  expect(useInstance.instance, isA<TestController>());

  Reactter.unregister<TestController>(id);
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
  Reactter.unregister<TestController>(id);

  expectLater(instance, isA<TestController>());
}
