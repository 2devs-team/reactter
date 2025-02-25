part of '../internals.dart';

/// {@template reactter.i_observer}
/// An abstract class representing an observer.
/// {@endtemplate}
@internal
abstract class IObserver {}

/// {@template reactter.i_state_observer}
/// An abstract class that defines the interface for observing lifecycle of states.
/// {@endtemplate}
@internal
abstract class IStateObserver implements IObserver {
  /// A set of all registered state observers.
  static final _observers = <IStateObserver>{};

  /// {@template reactter.i_state_observer.on_state_created}
  /// Called when a state is created.
  ///
  /// [state] - The state that was created.
  /// {@endtemplate}
  void onStateCreated(covariant IState state);

  /// {@template reactter.i_state_observer.on_state_bound}
  /// Called when a state is bound to an instance.
  ///
  /// [state] - The state that was bound.
  ///
  /// [instance] - The instance to which the state was bound.
  /// {@endtemplate}
  void onStateBound(covariant IState state, Object instance);

  /// {@template reactter.i_state_observer.on_state_unbound}
  /// Called when a state is unbound from an instance.
  ///
  /// [state] - The state that was unbound.
  ///
  /// [instance] - The instance from which the state was unbound.
  /// {@endtemplate}
  void onStateUnbound(covariant IState state, Object instance);

  /// {@template reactter.i_state_observer.on_state_updated}
  /// Called when a state is updated.
  ///
  /// [state] - The state that was updated.
  /// {@endtemplate}
  void onStateUpdated(covariant IState state);

  /// {@template reactter.i_state_observer.on_state_mounted}
  /// Called when a state is disposed.
  ///
  /// [state] - The state that was disposed.
  /// {@endtemplate}
  void onStateDisposed(covariant IState state);
}

/// {@template reactter.i_dependency_observer}
/// An abstract class that defines the interface for observing lifecycle of dependencies.
/// {@endtemplate}
@internal
abstract class IDependencyObserver implements IObserver {
  /// A set of all registered dependency observers.
  static final _observers = <IDependencyObserver>{};

  /// {@template reactter.i_dependency_observer.on_dependency_registered}
  /// Called when a dependency is registered.
  ///
  /// [dependency] - The dependency that was registered.
  /// {@endtemplate}
  void onDependencyRegistered(covariant DependencyRef dependency);

  /// {@template reactter.i_dependency_observer.on_dependency_created}
  /// Called when a dependency is created.
  ///
  /// [dependency] - The dependency that was created.
  ///
  /// [instance] - The instance of the dependency.
  /// {@endtemplate}
  void onDependencyCreated(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// {@template reactter.i_dependency_observer.on_dependency_mounted}
  /// Called when a dependency is mounted.
  ///
  /// [dependency] - The dependency that was mounted.
  ///
  /// [instance] - The instance of the dependency.
  /// {@endtemplate}
  void onDependencyMounted(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// {@template reactter.i_dependency_observer.on_dependency_unmounted}
  /// Called when a dependency is unmounted.
  ///
  /// [dependency] - The dependency that was unmounted.
  ///
  /// [instance] - The instance of the dependency.
  /// {@endtemplate}
  void onDependencyUnmounted(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// {@template reactter.i_dependency_observer.on_dependency_deleted}
  /// Called when a dependency is deleted.
  ///
  /// [dependency] - The dependency that was deleted.
  ///
  /// [instance] - The instance of the dependency.
  /// {@endtemplate}
  void onDependencyDeleted(
    covariant DependencyRef dependency,
    Object? instance,
  );

  /// {@template reactter.i_dependency_observer.on_dependency_unregistered}
  /// Called when a dependency is unregistered.
  ///
  /// [dependency] - The dependency that was unregistered.
  /// {@endtemplate}
  void onDependencyUnregistered(covariant DependencyRef dependency);

  /// {@template reactter.i_dependency_observer.on_dependency_failed}
  /// Called when a dependency fails.
  ///
  /// [dependency] - The dependency that failed.
  ///
  /// [fail] - The reason for the failure.
  /// {@endtemplate}
  void onDependencyFailed(
    covariant DependencyRef dependency,
    DependencyFail fail,
  );
}

/// {@template reactter.dependency_fail}
/// An enum representing the reasons for a dependency failure.
/// {@endtemplate}
enum DependencyFail {
  alreadyRegistered,
  alreadyCreated,
  alreadyDeleted,
  alreadyUnregistered,
  missingInstanceBuilder,
  builderRetained,
  dependencyRetained,
  cannotUnregisterActiveInstance,
}
