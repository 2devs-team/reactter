part of '../core.dart';

enum Lifecycle {
  /// This event is triggered when the [ReactterInstanceManager] registers the instance.
  registered,

  /// This event is triggered when the [ReactterInstanceManager] unregisters the instance.
  unregistered,

  /// This event is triggered when the [ReactterInstanceManager] initializes the instance.
  initialized,

  /// This event(exclusive to `flutter_reactter`) happens when the instance is going to be mounted in the widget tree.
  willMount,

  /// This event(exclusive to `flutter_reactter`) happens after the instance has been successfully mounted in the widget tree.
  didMount,

  /// This event is triggered anytime the instance's state is about to be updated. The event parameter is a [ReactterState].
  willUpdate,

  /// This event is triggered anytime the instance's state has been updated. The event parameter is a [ReactterState].
  didUpdate,

  /// This event(exclusive to `flutter_reactter`) happens when the instance is about to be unmounted from the widget tree.
  willUnmount,

  /// This event is triggered when the [ReactterInstanceManager] destroys the instance.
  destroyed,
}
