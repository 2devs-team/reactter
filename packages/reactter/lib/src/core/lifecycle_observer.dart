part of '../internals.dart';

/// {@template reactter.dependency_lifecycle}
/// It's a mixin that provides a set of methods that can be used to observe
/// the lifecycle of a dependency.
///
/// Example usage:
/// ```dart
/// class MyController with DependencyLifecycle {
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
abstract class DependencyLifecycle {
  /// This method is called when the dependency instance is created.
  void onCreated();

  /// This method is called when the dependency is going to be mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onWillMount();

  /// This method is called when the dependency has been successfully mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onDidMount();

  /// This method is called when the dependency's state is about to be updated.
  /// The parameter is a [IState].
  void onWillUpdate(covariant IState? state);

  /// This method is called when the dependency's state has been updated.
  /// The parameter is a [IState].
  void onDidUpdate(covariant IState? state);

  /// This method is called when the dependency is going to be unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onWillUnmount();

  /// This method is called when the dependency has been successfully unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onDidUnmount();
}

void _processLifecycleCallbacks(
  DependencyLifecycle observer,
  Lifecycle lifecycle, [
  dynamic param,
]) {
  switch (lifecycle) {
    case Lifecycle.created:
      observer.onCreated();
      break;
    case Lifecycle.willMount:
      observer.onWillMount();
      break;
    case Lifecycle.didMount:
      observer.onDidMount();
      break;
    case Lifecycle.willUpdate:
      observer.onWillUpdate(param);
      break;
    case Lifecycle.didUpdate:
      observer.onDidUpdate(param);
      break;
    case Lifecycle.willUnmount:
      observer.onWillUnmount();
      break;
    case Lifecycle.didUnmount:
      observer.onDidUnmount();
      break;
    default:
      break;
  }
}
