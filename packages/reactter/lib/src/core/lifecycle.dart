part of '../internals.dart';

enum Lifecycle {
  /// This event is triggered when the [DependencyInjection] registers the dependency.
  registered,

  /// This event is triggered when the [DependencyInjection] initializes the dependency.
  @Deprecated(
    'Use `Lifecycle.created` instead. '
    'This feature was deprecated after v7.2.0.',
  )
  initialized,

  /// This event is triggered when the [DependencyInjection] created the dependency instance.
  created,

  /// This event(exclusive to `flutter_reactter`) happens when the dependency is going to be mounted in the widget tree.
  willMount,

  /// This event(exclusive to `flutter_reactter`) happens after the dependency has been successfully mounted in the widget tree.
  didMount,

  /// This event is triggered anytime the dependency's state is about to be updated. The event parameter is a [IState].
  willUpdate,

  /// This event is triggered anytime the dependency's state has been updated. The event parameter is a [IState].
  didUpdate,

  /// This event(exclusive to `flutter_reactter`) happens when the dependency is going to be unmounted from the widget tree.
  willUnmount,

  /// This event(exclusive to `flutter_reactter`) happens when the dependency has been successfully unmounted from the widget tree.
  didUnmount,

  /// This event is triggered when the [DependencyInjection] destroys the dependency.
  @Deprecated(
    'Use `Lifecycle.deleted` instead. '
    'This feature was deprecated after v7.2.0.',
  )
  destroyed,

  /// This event is triggered when the [DependencyInjection] destroys the dependency instance.
  deleted,

  /// This event is triggered when the [DependencyInjection] unregisters the dependency.
  unregistered,
}
