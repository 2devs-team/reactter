part of '../framework.dart';

/// {@template reactter.rt_dependency_lifecycle}
/// It's a mixin that provides a set of methods that can be used to observe
/// the lifecycle of a dependency.
///
/// Example usage:
/// ```dart
/// class MyController with RtDependencyLifecycle {
///   final state = UseState('initial');
///
///   @override
///   void onCreated() {
///     print('MyController has been initialized');
///   }
///
///   @override
///   void onDidUpdate(RtState? state) {
///     print("$state has been changed");
///   }
/// }
///
/// // MyController has been initialized
/// final myController = Rt.create(() => MyController());
/// // state has been changed
/// myController.state.value = "value changed";
/// ```

/// {@endtemplate}
abstract class RtDependencyLifecycle implements DependencyLifecycle {
  /// This method is called when the dependency instance is created.
  @override
  void onCreated() {}

  /// This method is called when the dependency is going to be mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  @override
  void onWillMount() {}

  /// This method is called when the dependency has been successfully mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  @override
  void onDidMount() {}

  /// This method is called when the dependency's state is about to be updated.
  /// The parameter is a [IState].
  @override
  void onWillUpdate(covariant IState? state) {}

  /// This method is called when the dependency's state has been updated.
  /// The parameter is a [IState].
  @override
  void onDidUpdate(covariant IState? state) {}

  /// This method is called when the dependency is going to be unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  @override
  void onWillUnmount() {}

  /// This method is called when the dependency has been successfully unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  @override
  void onDidUnmount() {}
}
