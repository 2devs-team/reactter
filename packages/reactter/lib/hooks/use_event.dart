part of '../hooks.dart';

/// All UseEvent's events.
HashMap<Object?, HashMap<Enum, Set<Function>>> _events = HashMap();

/// A hook that manages events.
///
/// Allows to handle event of instance wherever.
/// Using it with the instance directly:
///
/// ```dart
/// UseEvent.withInstance(appContext);
/// ```
///
/// or using it with [T] instance
/// that it to has been registed with [ReactterInstanceManager]:
///
/// ```dart
/// UseEvent<AppContext>();
/// ```
///
/// if it has a [id]:
///
/// ```dart
/// UseEvent<AppContext>('uniqueId');
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
/// UseEvent<AppContext>().on(Events.SomeEvent, _onSomeEvent);
/// ```
///
/// use [off] method to stop listening event:
///
/// ```dart
/// UseEvent<AppContext>().off(Events.SomeEvent, _onSomeEvent);
/// ```
///
/// If you want to listen to event only once, use [one] method:
///
/// ```dart
/// UseEvent<AppContext>().one(Events.SomeEvent, _onSomeEvent);
/// ```
///
/// And use [emit] method to trigger event:
///
/// ```dart
/// UseEvent<AppContext>().emit(Events.SomeEvent, 'Parameter');
/// ```
///
/// **IMPORTANT**: Don't forget to remove event using [off]
/// or using [dispose] to remove all instance's events.
/// Failure to do so could increase memory usage
/// or have unexpected behaviors such as events in permanent listening.
///
/// See also:
/// - [ReactterInstanceManager], a instances manager.
class UseEvent<T extends Object?> {
  Object? _instanceReceived;

  Object? get _instance => _instanceReceived is ReactterInstance
      ? Reactter.instances.lookup(_instanceReceived)?.instance
      : _instanceReceived;

  ReactterInstance? get _reactterInstance =>
      _instanceReceived is ReactterInstance
          ? (_instanceReceived as ReactterInstance)
          : Reactter.find(_instanceReceived);

  UseEvent([String? _id]) : _instanceReceived = ReactterInstance<T?>(_id);

  UseEvent.withInstance(T instance)
      : assert(instance != null),
        _instanceReceived = Reactter.find(instance) ?? instance;

  /// Puts on to listen [eventName] event.
  ///
  /// When the event is [emit]ted, the [callback] is called.
  void on<P extends dynamic>(Enum eventName, CallbackEvent<T, P> callback) {
    _events[_instanceReceived] ??= HashMap();
    _events[_instanceReceived]?[eventName] ??= HashSet();
    _events[_instanceReceived]?[eventName]?.add(callback);
  }

  /// Puts on to listen [eventName] event only once.
  ///
  /// When the event is [emit]ted, the [callback] is called
  /// and after removes [eventName] event.
  void one<P>(Enum eventName, CallbackEvent<T, P> callback) {
    void _oneCallback(inst, param) {
      callback(inst, param);

      off(eventName, callback);
      off(eventName, _oneCallback);
    }

    on<P>(eventName, _oneCallback);
  }

  /// Removes the [callback] of [eventName] event.
  void off<P>(Enum eventName, CallbackEvent<T, P> callback) {
    _events[_instanceReceived]?[eventName]?.remove(callback);

    if (_events[_instanceReceived]?[eventName]?.isEmpty ?? false) {
      _events[_instanceReceived]?.remove(eventName);
    }

    if (_events[_instanceReceived]?.isEmpty ?? false) {
      _events.remove(_instanceReceived);
    }
  }

  /// Trigger [eventName] event with or without the [param] given.
  void emit(Enum eventName, [dynamic param]) {
    final callbacks = HashSet()
      ..addAll(
        _events[_instance]?[eventName] ?? {},
      )
      ..addAll(
        _events[_reactterInstance]?[eventName] ?? {},
      );

    for (var callback in callbacks) {
      callback(_instance, param);
    }
  }

  /// Removes all instance's events
  void dispose() {
    _events
      ..remove(_instance)
      ..remove(_reactterInstance);

    _instanceReceived = null;
  }
}
