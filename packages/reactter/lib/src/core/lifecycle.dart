part of 'core.dart';

enum Lifecycle {
  /// This event is triggered when the [InstanceManager] registers the instance.
  registered,

  /// This event is triggered when the [InstanceManager] unregisters the instance.
  unregistered,

  /// This event is triggered when the [InstanceManager] initializes the instance.
  initialized,

  /// This event(exclusive to `flutter_reactter`) happens when the instance is going to be mounted in the widget tree.
  willMount,

  /// This event(exclusive to `flutter_reactter`) happens after the instance has been successfully mounted in the widget tree.
  didMount,

  /// This event is triggered anytime the instance's state is about to be updated. The event parameter is a [StateBase].
  willUpdate,

  /// This event is triggered anytime the instance's state has been updated. The event parameter is a [StateBase].
  didUpdate,

  /// This event(exclusive to `flutter_reactter`) happens when the instance is going to be unmounted from the widget tree.
  willUnmount,

  /// This event(exclusive to `flutter_reactter`) happens when the instance has been successfully unmounted from the widget tree.
  didUnmount,

  /// This event is triggered when the [InstanceManager] destroys the instance.
  destroyed,
}

abstract class LifecycleObserver {
  /// This method is called when the instance is initialized.
  void onInitialized() {}

  /// This method is called when the instance is going to be mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onWillMount() {}

  /// This method is called when the instance has been successfully mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onDidMount() {}

  /// This method is called when the instance's state is about to be updated.
  /// The parameter is a [StateBase].
  void onWillUpdate(StateBase? state) {}

  /// This method is called when the instance's state has been updated.
  /// The parameter is a [StateBase].
  void onDidUpdate(StateBase? state) {}

  /// This method is called when the instance is going to be unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onWillUnmount() {}

  /// This method is called when the instance has been successfully unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onDidUnmount() {}
}

/// Resolves the lifecycle event of a [LifecycleObserver] instance.
/// The appropriate lifecycle method of the [instance] is invoked based on the [event].
///
/// The [instance] is the [LifecycleObserver] instance whose lifecycle event is being resolved.
/// The [event] parameter represents the lifecycle event that occurred.
/// The [param] parameter is an optional parameter that can be passed to some lifecycle methods.
@internal
void resolveLifecycle(
  LifecycleObserver instance,
  Lifecycle event,
  Object? param,
) {
  switch (event) {
    case Lifecycle.initialized:
      instance.onInitialized();
      break;
    case Lifecycle.willMount:
      instance.onWillMount();
      break;
    case Lifecycle.didMount:
      instance.onDidMount();
      break;
    case Lifecycle.willUpdate:
      instance.onWillUpdate(param is StateBase ? param : null);
      break;
    case Lifecycle.didUpdate:
      instance.onDidUpdate(param is StateBase ? param : null);
      break;
    case Lifecycle.willUnmount:
      instance.onWillUnmount();
      break;
    case Lifecycle.didUnmount:
      instance.onDidUnmount();
      break;
    default:
      break;
  }
}
