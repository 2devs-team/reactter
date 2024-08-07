part of 'core.dart';

/// {@template lifecycle_observer}
/// It's a mixin that provides a set of methods that can be used to observe
/// the lifecycle of a dependency.
///
/// Example usage:
/// ```dart
/// class MyController with LifecycleObserver {
///   final state = UseState('initial');
///
///   @override
///   void onInitialized() {
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
abstract class LifecycleObserver {
  /// This method is called when the dependency is initialized.
  @Deprecated(
    'Use `onCreated` instead. '
    'This feature was deprecated after v7.2.0.',
  )
  void onInitialized() {}

  /// This method is called when the dependency instance is created.
  void onCreated() {}

  /// This method is called when the dependency is going to be mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onWillMount() {}

  /// This method is called when the dependency has been successfully mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onDidMount() {}

  /// This method is called when the dependency's state is about to be updated.
  /// The parameter is a [StateBase].
  void onWillUpdate(covariant StateBase? state) {}

  /// This method is called when the dependency's state has been updated.
  /// The parameter is a [StateBase].
  void onDidUpdate(covariant StateBase? state) {}

  /// This method is called when the dependency is going to be unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onWillUnmount() {}

  /// This method is called when the dependency has been successfully unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onDidUnmount() {}
}

void _executeLifecycleObserver(
  LifecycleObserver observer,
  Lifecycle lifecycle, [
  StateBase? state,
]) {
  switch (lifecycle) {
    // ignore: deprecated_member_use_from_same_package
    case Lifecycle.initialized:
      // ignore: deprecated_member_use_from_same_package
      observer.onInitialized();
      break;
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
      observer.onWillUpdate(state);
      break;
    case Lifecycle.didUpdate:
      observer.onDidUpdate(state);
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
