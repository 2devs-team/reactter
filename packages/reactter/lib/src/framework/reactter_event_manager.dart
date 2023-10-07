part of '../framework.dart';

/// A abstract-class that adds events management features to classes that use it.
///
/// It contains methods for adding, removing, and triggering events,
/// as well as storing event callbacks.
abstract class ReactterEventManager {
  /// Event's store.
  HashMap<String, List<String>> _instanceEvents = HashMap();
  HashMap<String, HashSet<Function>> _events = HashMap();
  HashMap<String, Function> _oneCallbacks = HashMap();

  /// Puts on to listen [eventName] event.
  ///
  /// When the event is [emit]ted, the [callback] is called.
  void on<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    final _instanceEventKey = _getInstanceEventKey(instance, eventName);
    final _instanceKey = _instanceEventKey.first;
    final _eventKey = _instanceEventKey.last;

    _instanceEvents[_instanceKey] ??= [];
    _instanceEvents[_instanceKey]?.add(_eventKey);

    _events[_eventKey] ??= HashSet();
    _events[_eventKey]?.add(callback);
  }

  /// Puts on to listen [eventName] event only once.
  ///
  /// When the event is [emit]ted, the [callback] is called
  /// and after removes event.
  void one<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    final _instanceEventKey =
        _getInstanceEventKey(instance, eventName, callback);
    final _eventOneKey = _instanceEventKey.last;

    void _oneCallback(inst, param) {
      callback(inst, param);

      _oneOff<T, P>(instance, eventName, callback);
    }

    _oneCallbacks[_eventOneKey] ??= _oneCallback;

    on<T, P>(instance, eventName, _oneCallback);
  }

  /// Removes the [callback] of event.
  void off<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    _oneOff<T, P>(instance, eventName, callback);

    final _instanceEventKey = _getInstanceEventKey(instance, eventName);
    final _instanceKey = _instanceEventKey.first;
    final _eventKey = _instanceEventKey.last;

    if (!(_events[_eventKey]?.contains(callback) ?? false)) {
      return;
    }

    _events[_eventKey]?.remove(callback);

    if (_events[_eventKey]?.isEmpty ?? false) {
      _events.remove(_eventKey);
      _instanceEvents[_instanceKey]?.remove(_eventKey);

      if (_instanceEvents[_instanceKey]?.isEmpty ?? false) {
        _instanceEvents.remove(_instanceKey);
      }
    }
  }

  /// Trigger [eventName] event with or without the [param] given.
  void emit(
    Object? instance,
    Enum eventName, [
    dynamic param,
  ]) {
    final callbacks = {
      ...?_events[_getEventKey(instance, eventName)],
      ...?_events["${instance.hashCode}.${eventName.hashCode}"],
    };

    for (var callback in callbacks) {
      callback(_getInstance(instance), param);
    }
  }

  /// Trigger [eventName] event with or without the [param] given as async way.
  Future<void> emitAsync(
    Object? instance,
    Enum eventName, [
    dynamic param,
  ]) async {
    final callbacks = {
      ...?_events[_getEventKey(instance, eventName)],
      ...?_events["${instance.hashCode}.${eventName.hashCode}"],
    };

    await Future.wait(
      callbacks.map(
        (callback) => Future.microtask(
          () => callback(_getInstance(instance), param),
        ),
      ),
    );
  }

  /// Removes all instance's events
  void offAll(Object? instance) {
    final instanceKey = ReactterInstance.getInstanceKey(instance);
    final eventKeys = Set.from(_instanceEvents[instanceKey] ?? []);

    eventKeys.forEach((key) => _events.remove(key));

    /// instanceKey with a dot, to prevent another event containing
    /// the same starts number of the instanceKey from being removed.
    ///
    /// _oneCallbacks = {
    ///   "6778923.4576": [...],
    ///   "67789.4523": [...],
    ///   ...
    /// };
    /// instanceKey = "67789"; <- This could remove another event, it is not expected.
    /// instanceKeyWithDot = "67789."; <- This remove event correctly.
    final instanceKeyWithDot = "$instanceKey.";
    _oneCallbacks.removeWhere(
      (key, value) => key.startsWith(instanceKeyWithDot),
    );
  }

  /// Returns a combination of the instance key, the event name key,
  /// and the callback key. This optimizes event storage.
  List<String> _getInstanceEventKey(
    Object? instance,
    Enum eventName, [
    Function? callback,
  ]) {
    final instanceKey = ReactterInstance.getInstanceKey(instance);

    if (callback == null) {
      return [instanceKey, "$instanceKey.${eventName.hashCode}"];
    }

    return [
      instanceKey,
      "$instanceKey.${eventName.hashCode}.${callback.hashCode}"
    ];
  }

  /// Returns a combination of the instance key, the event name key,
  /// and the callback key. This optimizes event storage.
  String _getEventKey(
    Object? instance,
    Enum eventName, [
    Function? callback,
  ]) {
    return _getInstanceEventKey(instance, eventName, callback).last;
  }

  Object? _getInstance(Object? instance) {
    return instance is ReactterInstance ? instance.stored?.instance : instance;
  }

  /// Removes a one callback event from a _oneCallbacks if it exists.
  void _oneOff<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    final _eventOneKey = _getEventKey(instance, eventName, callback);
    final _oneCallbackFound = _oneCallbacks[_eventOneKey];

    if (_oneCallbackFound != null) {
      off(instance, eventName, _oneCallbackFound as CallbackEvent);
      _oneCallbacks.remove(_eventOneKey);
    }
  }

  /// Checks if an object has any listeners.
  bool _hasListeners(Object? instance) {
    return _instanceEvents.containsKey(
      ReactterInstance.getInstanceKey(instance),
    );
  }
}
