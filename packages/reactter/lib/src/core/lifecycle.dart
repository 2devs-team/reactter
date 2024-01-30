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
