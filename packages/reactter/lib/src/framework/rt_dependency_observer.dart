part of '../internals.dart';

enum DependencyFail {
  alreadyRegistered,
  alreadyCreated,
  alreadyDeleted,
  alreadyUnregistered,
  missingInstanceBuilder,
  builderRetainedAsFactory,
  dependencyRetainedAsSingleton,
  cannotUnregisterActiveInstance,
}

/// {@template reactter.rt_dependency_observer}
/// An abstract class that defines the interface for observing dependency changes.
/// Implementations of this class can be used to monitor the lifecycle of dependencies.
/// {@endtemplate}
abstract class RtDependencyObserver implements IObserver {
  /// A set of all registered dependency observers.
  static final _observers = <RtDependencyObserver>{};

  /// Called when a dependency is registered.
  /// [dependency] - The dependency that was registered.
  void onDependencyRegistered(covariant DependencyRef dependency);

  /// Called when a dependency is created.
  /// [dependency] - The dependency that was created.
  /// [instance] - The instance of the dependency.
  void onDependencyCreated(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// Called when a dependency is mounted.
  /// [dependency] - The dependency that was mounted.
  /// [instance] - The instance of the dependency.
  void onDependencyMounted(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// Called when a dependency is unmounted.
  /// [dependency] - The dependency that was unmounted.
  /// [instance] - The instance of the dependency.
  void onDependencyUnmounted(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// Called when a dependency is deleted.
  /// [dependency] - The dependency that was deleted.
  /// [instance] - The instance of the dependency.
  void onDependencyDeleted(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// Called when a dependency is unregistered.
  /// [dependency] - The dependency that was unregistered.
  void onDependencyUnregistered(covariant DependencyRef dependency);

  void onDependencyFailed(
    covariant DependencyRef dependency,
    DependencyFail fail,
  );
}
