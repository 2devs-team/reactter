import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/src/internals.dart';

import '../shareds/test_controllers.dart';

void main() {
  group("RtDependencyObserver", () {
    test("should be observed when a dependency is registered", () {
      bool onRegisteredCalled = false;

      final observer = RtDependencyObserver(
        onRegistered: (dependencyRef) {
          expect(dependencyRef, isA<DependencyRegister<TestController>>());
          onRegisteredCalled = true;
        },
      );
      Rt.addObserver(observer);

      Rt.register<TestController>(() => TestController());

      expect(onRegisteredCalled, isTrue);

      Rt.removeObserver(observer);
      Rt.unregister<TestController>();
    });

    test("should be observed when a dependency is created", () {
      bool onCreatedCalled = false;
      dynamic instanceCreated;

      final observer = RtDependencyObserver(
        onCreated: (dependencyRef, instance) {
          expect(dependencyRef, isA<DependencyRegister<TestController>>());
          expect(instance, isA<TestController>());
          onCreatedCalled = true;
          instanceCreated = instance;
        },
      );
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());

      expect(onCreatedCalled, isTrue);
      expect(instanceCreated, instance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });

    test("should be observed when a dependency is mounted", () {
      bool onMountedCalled = false;
      dynamic instanceMounted;

      final observer = RtDependencyObserver(
        onMounted: (dependencyRef, instance) {
          expect(dependencyRef, isA<RtDependencyRef<TestController>>());
          expect(instance, isA<TestController>());
          onMountedCalled = true;
          instanceMounted = instance;
        },
      );
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());
      Rt.emit(RtDependencyRef<TestController>(), Lifecycle.didMount, instance);

      expect(onMountedCalled, isTrue);
      expect(instanceMounted, instance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });

    test("should be observed when a dependency is unmounted", () {
      bool onUnmountedCalled = false;
      dynamic instanceUnmounted;

      final observer = RtDependencyObserver(
        onUnmounted: (dependencyRef, instance) {
          expect(dependencyRef, isA<RtDependencyRef<TestController>>());
          expect(instance, isA<TestController>());
          onUnmountedCalled = true;
          instanceUnmounted = instance;
        },
      );
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());
      Rt.emit(
          RtDependencyRef<TestController>(), Lifecycle.didUnmount, instance);

      expect(onUnmountedCalled, isTrue);
      expect(instanceUnmounted, instance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });

    test("should be observed when a dependency is deleted", () {
      bool onDeletedCalled = false;
      dynamic instanceDeleted;

      final observer = RtDependencyObserver(
        onDeleted: (dependencyRef, instance) {
          expect(dependencyRef, isA<DependencyRegister<TestController>>());
          expect(instance, isA<TestController>());
          onDeletedCalled = true;
          instanceDeleted = instance;
        },
      );
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());
      Rt.delete<TestController>();

      expect(onDeletedCalled, isTrue);
      expect(instanceDeleted, instance);

      Rt.removeObserver(observer);
    });

    test("should be observed when a dependency is unregistered", () {
      bool onUnregisteredCalled = false;

      final observer = RtDependencyObserver(
        onUnregistered: (dependencyRef) {
          expect(dependencyRef, isA<DependencyRegister<TestController>>());
          onUnregisteredCalled = true;
        },
      );
      Rt.addObserver(observer);

      Rt.register<TestController>(() => TestController());
      Rt.unregister<TestController>();

      expect(onUnregisteredCalled, isTrue);

      Rt.removeObserver(observer);
    });

    test("should be observed when a dependency is failed", () {
      int onFailedCalledCount = 0;
      DependencyFail? lastFail;

      final observer = RtDependencyObserver(
        onFailed: (dependencyRef, fail) {
          expect(dependencyRef is DependencyRef<TestController?>, isTrue);
          expect(fail, isA<DependencyFail>());
          onFailedCalledCount++;
          lastFail = fail;
        },
      );
      Rt.addObserver(observer);

      Rt.create(() => TestController());
      Rt.register(() => TestController());

      expect(onFailedCalledCount, 1);
      expect(lastFail, DependencyFail.alreadyRegistered);

      Rt.create(() => TestController());

      // before the last fail, it should be `DependencyFail.alreadyRegistered` again.
      expect(onFailedCalledCount, 3);
      expect(lastFail, DependencyFail.alreadyCreated);

      Rt.delete<TestController>();
      Rt.delete<TestController>();

      expect(onFailedCalledCount, 4);
      expect(lastFail, DependencyFail.alreadyDeleted);

      Rt.unregister<TestController>();

      expect(onFailedCalledCount, 5);
      expect(lastFail, DependencyFail.alreadyUnregistered);

      Rt.get<TestController>();

      expect(onFailedCalledCount, 6);
      expect(lastFail, DependencyFail.missingInstanceBuilder);

      Rt.create(() => TestController(), mode: DependencyMode.factory);
      Rt.delete<TestController>();

      expect(onFailedCalledCount, 7);
      expect(lastFail, DependencyFail.builderRetained);

      Rt.destroy<TestController>();
      Rt.create(() => TestController(), mode: DependencyMode.singleton);
      Rt.delete<TestController>();

      expect(onFailedCalledCount, 8);
      expect(lastFail, DependencyFail.dependencyRetained);

      Rt.unregister<TestController>();

      expect(onFailedCalledCount, 9);
      expect(lastFail, DependencyFail.cannotUnregisterActiveInstance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });
  });
}
