// ignore_for_file: constant_identifier_names

import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

import '../shareds/test_controllers.dart';

const ID = 'uniqueId';

void main() {
  group("UseDependency", () {
    test("should get a dependency", () => _testController());

    test("should get a dependency with id", () => _testController(ID));

    test("should get a dependency late", () => _testControllerLate());

    test("should get a dependency with id late", () => _testControllerLate(ID));

    test("should register a dependency", () {
      final useDependency = UseDependency.register(() => TestController());
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>();
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      Rt.destroy<TestController>();
    });

    test("should register a dependency with id", () {
      final useDependency =
          UseDependency.register(() => TestController(), id: ID);
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>(ID);
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      Rt.destroy<TestController>(id: ID);
    });

    test("should register a dependency in builder mode", () {
      final useDependency = UseDependency.lazyBuilder(() => TestController());
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>();
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.builder);

      Rt.destroy<TestController>();
    });

    test("should register a dependency with id in builder mode", () {
      final useDependency =
          UseDependency.lazyBuilder(() => TestController(), ID);
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>(ID);
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.builder);

      Rt.destroy<TestController>(id: ID);
    });

    test("should register a dependency in factory mode", () {
      final useDependency = UseDependency.lazyFactory(() => TestController());
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>();
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.factory);

      Rt.destroy<TestController>();
    });

    test("should register a dependency with id in factory mode", () {
      final useDependency =
          UseDependency.lazyFactory(() => TestController(), ID);
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>(ID);
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.factory);

      Rt.destroy<TestController>(id: ID);
    });

    test("should register a dependency in singleton mode", () {
      final useDependency = UseDependency.lazySingleton(() => TestController());
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>();
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.singleton);

      Rt.destroy<TestController>();
    });

    test("should register a dependency with id in singleton mode", () {
      final useDependency =
          UseDependency.lazySingleton(() => TestController(), ID);
      expect(useDependency.instance, null);

      final instance = Rt.get<TestController>(ID);
      expect(useDependency.instance, instance);

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.singleton);

      Rt.destroy<TestController>(id: ID);
    });

    test("should create a dependency", () {
      final useDependency = UseDependency.create(() => TestController());
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      Rt.destroy<TestController>();
    });

    test("should create a dependency in builder mode", () {
      final useDependency = UseDependency.builder(() => TestController());
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.builder);

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id in builder mode", () {
      final useDependency = UseDependency.builder(() => TestController(), ID);
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.builder);

      Rt.destroy<TestController>(id: ID);
    });

    test("should create a dependency in factory mode", () {
      final useDependency = UseDependency.factory(() => TestController());
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.factory);

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id in factory mode", () {
      final useDependency = UseDependency.factory(() => TestController(), ID);
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.factory);

      Rt.destroy<TestController>(id: ID);
    });

    test("should create a dependency in singleton mode", () {
      final useDependency = UseDependency.singleton(() => TestController());
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.singleton);

      Rt.destroy<TestController>();
    });

    test("should create a dependency with id in singleton mode", () {
      final useDependency = UseDependency.singleton(() => TestController(), ID);
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      final dependencyMode = Rt.getDependencyMode(useDependency.instance);
      expect(dependencyMode, DependencyMode.singleton);

      Rt.destroy<TestController>(id: ID);
    });

    test("should get a dependency", () {
      Rt.register(() => TestController());

      final useDependency = UseDependency<TestController>.get();
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      Rt.destroy<TestController>();
    });

    test("should get a dependency with id", () {
      Rt.register(() => TestController(), id: ID);

      final useDependency = UseDependency<TestController>.get(ID);
      expect(useDependency.instance, isA<TestController>());

      final isActive = Rt.isActive(useDependency.instance);
      expect(isActive, true);

      Rt.destroy<TestController>(id: ID);
    });
  });
}

void _testController([String? id]) {
  Rt.create(() => TestController(), id: id);

  final useDependency = UseDependency<TestController>(id);

  expect(useDependency.instance, isA<TestController>());

  Rt.destroy<TestController>(id: id);
}

void _testControllerLate([String? id]) {
  late final TestController instance;
  final useDependency = UseDependency<TestController>(id);

  UseEffect(() {
    if (useDependency.instance != null) {
      instance = useDependency.instance!;
    }
  }, [useDependency]);

  Rt.create(() => TestController(), id: id);
  Rt.destroy<TestController>(id: id);

  expectLater(instance, isA<TestController>());
}
