import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/src/internals.dart';

import '../shareds/test_controllers.dart';

class RtDependencyObserverTest extends RtDependencyObserver {
  int onDependencyRegisteredCalledCount = 0;

  int onDependencyCreatedCalledCount = 0;
  Object? lastInstanceCreated;

  int onDependencyMountedCalledCount = 0;
  Object? lastInstanceMounted;

  int onDependencyUnmountedCalledCount = 0;
  Object? lastInstanceUnmounted;

  int onDependencyDeletedCalledCount = 0;
  Object? lastInstanceDeleted;

  int onDependencyUnregisteredCalledCount = 0;

  int onDependencyFailedCalledCount = 0;
  DependencyFail? lastFail;

  @override
  void onDependencyRegistered(covariant DependencyRef<Object?> dependency) {
    onDependencyRegisteredCalledCount++;
  }

  @override
  void onDependencyCreated(
    covariant DependencyRef<Object?> dependency,
    Object? instance,
  ) {
    onDependencyCreatedCalledCount++;
    lastInstanceCreated = instance;
  }

  @override
  void onDependencyMounted(
    covariant DependencyRef<Object?> dependency,
    Object? instance,
  ) {
    onDependencyMountedCalledCount++;
    lastInstanceMounted = instance;
  }

  @override
  void onDependencyUnmounted(
    covariant DependencyRef<Object?> dependency,
    Object? instance,
  ) {
    onDependencyUnmountedCalledCount++;
    lastInstanceUnmounted = instance;
  }

  @override
  void onDependencyDeleted(
    covariant DependencyRef<Object?> dependency,
    Object? instance,
  ) {
    onDependencyDeletedCalledCount++;
    lastInstanceDeleted = instance;
  }

  @override
  void onDependencyUnregistered(covariant DependencyRef<Object?> dependency) {
    onDependencyUnregisteredCalledCount++;
  }

  @override
  void onDependencyFailed(
    covariant DependencyRef<Object?> dependency,
    DependencyFail fail,
  ) {
    onDependencyFailedCalledCount++;
    lastFail = fail;
  }
}

void main() {
  group("RtDependencyObserver", () {
    test("should be observed when a dependency is registered", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      Rt.register<TestController>(() => TestController());

      expect(observer.onDependencyRegisteredCalledCount, 1);

      Rt.addObserver(observer);
      Rt.unregister<TestController>();
    });

    test("should be observed when a dependency is created", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());

      expect(observer.onDependencyCreatedCalledCount, 1);
      expect(observer.lastInstanceCreated, instance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });

    test("should be observed when a dependency is mounted", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());
      Rt.emit(RtDependency<TestController>(), Lifecycle.didMount, instance);

      expect(observer.onDependencyMountedCalledCount, 1);
      expect(observer.lastInstanceMounted, instance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });

    test("should be observed when a dependency is unmounted", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());
      Rt.emit(RtDependency<TestController>(), Lifecycle.didUnmount, instance);

      expect(observer.onDependencyUnmountedCalledCount, 1);
      expect(observer.lastInstanceUnmounted, instance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });

    test("should be observed when a dependency is deleted", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      final instance = Rt.create(() => TestController());
      Rt.delete<TestController>();

      expect(observer.onDependencyDeletedCalledCount, 1);
      expect(observer.lastInstanceDeleted, instance);

      Rt.removeObserver(observer);
    });

    test("should be observed when a dependency is unregistered", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      Rt.register<TestController>(() => TestController());
      Rt.unregister<TestController>();

      expect(observer.onDependencyUnregisteredCalledCount, 1);

      Rt.removeObserver(observer);
    });

    test("should be observed when a dependency is failed", () {
      final observer = RtDependencyObserverTest();
      Rt.addObserver(observer);

      Rt.create(() => TestController());
      Rt.register(() => TestController());

      expect(observer.onDependencyFailedCalledCount, 1);
      expect(observer.lastFail, DependencyFail.alreadyRegistered);

      Rt.create(() => TestController());

      expect(observer.onDependencyFailedCalledCount, 3);
      // before the last fail, it should be `DependencyFail.alreadyRegistered` again.
      expect(observer.lastFail, DependencyFail.alreadyCreated);

      Rt.delete<TestController>();
      Rt.delete<TestController>();

      expect(observer.onDependencyFailedCalledCount, 4);
      expect(observer.lastFail, DependencyFail.alreadyDeleted);

      Rt.unregister<TestController>();

      expect(observer.onDependencyFailedCalledCount, 5);
      expect(observer.lastFail, DependencyFail.alreadyUnregistered);

      Rt.get<TestController>();

      expect(observer.onDependencyFailedCalledCount, 6);
      expect(observer.lastFail, DependencyFail.missingInstanceBuilder);

      Rt.create(() => TestController(), mode: DependencyMode.factory);
      Rt.delete<TestController>();

      expect(observer.onDependencyFailedCalledCount, 7);
      expect(observer.lastFail, DependencyFail.builderRetainedAsFactory);

      Rt.destroy<TestController>();
      Rt.create(() => TestController(), mode: DependencyMode.singleton);
      Rt.delete<TestController>();

      expect(observer.onDependencyFailedCalledCount, 8);
      expect(observer.lastFail, DependencyFail.dependencyRetainedAsSingleton);

      Rt.unregister<TestController>();

      expect(observer.onDependencyFailedCalledCount, 9);
      expect(observer.lastFail, DependencyFail.cannotUnregisterActiveInstance);

      Rt.removeObserver(observer);
      Rt.destroy<TestController>();
    });
  });
}
