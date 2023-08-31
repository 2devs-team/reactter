part of '../hooks.dart';

/// A hook that manages events.
///
/// Allows to handle event of instance wherever.
/// Using it with the instance directly:
///
/// ```dart
/// UseEvent.withInstance(appController);
/// ```
///
/// or using it with [T] instance
/// that it to has been registed with [ReactterInstanceManager]:
///
/// ```dart
/// UseEvent<AppController>();
/// ```
///
/// if it has a [id]:
///
/// ```dart
/// UseEvent<AppController>('uniqueId');
/// ```
///
/// You can listen to event using [on] method:
///
/// ```dart
/// enum Events { SomeEvent };
///
/// void _onSomeEvent(inst, param) {
///   print("$inst's Events.SomeEvent emitted with param: $param.");
/// }
///
/// UseEvent<AppController>().on(Events.SomeEvent, _onSomeEvent);
/// ```
///
/// use [off] method to stop listening event:
///
/// ```dart
/// UseEvent<AppController>().off(Events.SomeEvent, _onSomeEvent);
/// ```
///
/// If you want to listen to event only once, use [one] method:
///
/// ```dart
/// UseEvent<AppController>().one(Events.SomeEvent, _onSomeEvent);
/// ```
///
/// And use [emit] method to trigger event:
///
/// ```dart
/// UseEvent<AppController>().emit(Events.SomeEvent, 'Parameter');
/// ```
///
/// **IMPORTANT**: Don't forget to remove event using [off]
/// or using [dispose] to remove all instance's events.
/// Failure to do so could increase memory usage
/// or have unexpected behaviors such as events in permanent listening.
///
/// See also:
///
/// * [ReactterInstanceManager], a instances manager.
@Deprecated('Use event shortcuts instead.')
class UseEvent<T extends Object?> {
  final Object? _instanceReceived;

  UseEvent([String? id]) : _instanceReceived = ReactterInstance<T>(id);

  UseEvent.withInstance(T instance)
      : assert(instance != null),
        _instanceReceived = instance;

  /// Puts on to listen [eventName] event.
  ///
  /// When the event is [emit]ted, the [callback] is called.
  void on<P extends dynamic>(Enum eventName, CallbackEvent<T, P> callback) {
    Reactter.on<T, P>(_instanceReceived, eventName, callback);
  }

  /// Puts on to listen [eventName] event only once.
  ///
  /// When the event is [emit]ted, the [callback] is called
  /// and after removes [eventName] event.
  void one<P>(Enum eventName, CallbackEvent<T, P> callback) {
    Reactter.one<T, P>(_instanceReceived, eventName, callback);
  }

  /// Removes the [callback] of [eventName] event.
  void off<P>(Enum eventName, CallbackEvent<T, P> callback) {
    Reactter.off<T, P>(_instanceReceived, eventName, callback);
  }

  /// Triggers [eventName] event with or without the [param] given.
  void emit(Enum eventName, [dynamic param]) {
    Reactter.emit(_instanceReceived, eventName, param);
  }

  /// Removes all instance's events
  void dispose() => Reactter.dispose(_instanceReceived);
}
