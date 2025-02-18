part of '../framework.dart';

/// {@template reactter.rt_dependency_observer}
/// A class that implements the [IDependencyObserver] interface.
/// This class can be used to monitor the lifecycle of dependencies.
///
/// It provides a set of callback functions that are called when a dependency is
/// registered, created, mounted, unmounted, deleted, unregistered, or failed.
///
/// This observer should be added to Reactter's observers for it to work, using the [Rt.addObserver] method, like so:
/// ```dart
/// final dependencyObserver = RtDependencyObserver(
///   onRegistered: (dependency) {
///     print('Dependency registered: $dependency');
///   },
///   onCreated: (dependency, instance) {
///     print('Dependency created: $dependency, instance: $instance');
///   },
///   onMounted: (dependency, instance) {
///     print('Dependency mounted: $dependency, instance: $instance');
///   },
///   onUnmounted: (dependency, instance) {
///     print('Dependency unmounted: $dependency, instance: $instance');
///   },
///   onDeleted: (dependency, instance) {
///     print('Dependency deleted: $dependency, instance: $instance');
///   },
///   onUnregistered: (dependency) {
///     print('Dependency unregistered: $dependency');
///   },
///   onFailed: (dependency, fail) {
///     print('Dependency failed: $dependency, fail: $fail');
///   },
/// );
///
/// Rt.addObserver(dependencyObserver);
/// ```
///
/// See also:
/// - [IDependencyObserver] - An abstract class that defines the interface for observing dependency changes.
/// - [Rt.addObserver] - A method that adds an observer to Reactter's observers.
/// {@endtemplate}
class RtDependencyObserver implements IDependencyObserver {
  /// {@macro reactter.i_dependency_observer.on_dependency_registered}
  final void Function(DependencyRef)? onRegistered;

  /// {@macro reactter.i_dependency_observer.on_dependency_created}
  final void Function(DependencyRef, Object?)? onCreated;

  /// {@macro reactter.i_dependency_observer.on_dependency_mounted}
  final void Function(DependencyRef, Object?)? onMounted;

  /// {@macro reactter.i_dependency_observer.on_dependency_unmounted}
  final void Function(DependencyRef, Object?)? onUnmounted;

  /// {@macro reactter.i_dependency_observer.on_dependency_deleted}
  final void Function(DependencyRef, Object?)? onDeleted;

  /// {@macro reactter.i_dependency_observer.on_dependency_unregistered}
  final void Function(DependencyRef)? onUnregistered;

  /// {@macro reactter.i_dependency_observer.on_dependency_failed}
  final void Function(DependencyRef, DependencyFail)? onFailed;

  RtDependencyObserver({
    this.onRegistered,
    this.onCreated,
    this.onMounted,
    this.onUnmounted,
    this.onDeleted,
    this.onUnregistered,
    this.onFailed,
  });

  /// {@macro reactter.i_dependency_observer.on_dependency_registered}
  @override
  void onDependencyRegistered(DependencyRef dependency) {
    onRegistered?.call(dependency);
  }

  /// {@macro reactter.i_dependency_observer.on_dependency_created}
  @override
  void onDependencyCreated(DependencyRef dependency, Object? instance) {
    onCreated?.call(dependency, instance);
  }

  /// {@macro reactter.i_dependency_observer.on_dependency_mounted}
  @override
  void onDependencyMounted(DependencyRef dependency, Object? instance) {
    onMounted?.call(dependency, instance);
  }

  /// {@macro reactter.i_dependency_observer.on_dependency_unmounted}
  @override
  void onDependencyUnmounted(DependencyRef dependency, Object? instance) {
    onUnmounted?.call(dependency, instance);
  }

  /// {@macro reactter.i_dependency_observer.on_dependency_deleted}
  @override
  void onDependencyDeleted(DependencyRef dependency, Object? instance) {
    onDeleted?.call(dependency, instance);
  }

  /// {@macro reactter.i_dependency_observer.on_dependency_unregistered}
  @override
  void onDependencyUnregistered(DependencyRef dependency) {
    onUnregistered?.call(dependency);
  }

  /// {@macro reactter.i_dependency_observer.on_dependency_failed}
  @override
  void onDependencyFailed(DependencyRef dependency, DependencyFail fail) {
    onFailed?.call(dependency, fail);
  }
}
