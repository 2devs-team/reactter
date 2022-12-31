// ignore_for_file: constant_identifier_names
part of '../core.dart';

/// A mixin-class to provides the ability to manager events
mixin ReactterEventManager {
  /// Event's store.
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
    if (instance is ReactterNotifyManager) {
      instance._addListener();
    }

    final _eventKey = _getEventKey(instance, eventName);

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
    final _eventOneKey = _getEventKey(instance, eventName, callback);

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

    final _eventKey = _getEventKey(instance, eventName);

    if (!(_events[_eventKey]?.contains(callback) ?? false)) {
      return;
    }

    if (instance is ReactterNotifyManager) {
      instance._removeListener();
    }

    _events[_eventKey]?.remove(callback);

    if (_events[_eventKey]?.isEmpty ?? false) {
      _events.remove(_eventKey);
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
  void dispose(Object? instance) {
    /// instanceKey with a dot, to prevent another event containing
    /// the same starts number of the instanceKey from being removed.
    ///
    /// _events = {
    ///   "6778923.4576": [...],
    ///   "67789.4523": [...],
    ///   ...
    /// };
    /// instanceKey = "67789"; <- This could remove another event, it is not expected.
    /// instanceKeyWithDot = "67789."; <- This remove event correctly.
    final instanceKeyWithDot = "${_getInstanceKey(instance)}.";

    _events.removeWhere(
      (key, value) => key.startsWith(instanceKeyWithDot),
    );
    _oneCallbacks.removeWhere(
      (key, value) => key.startsWith(instanceKeyWithDot),
    );

    if (instance is ReactterNotifyManager) {
      instance._removeAllListeners();
    }
  }

  String _getInstanceKey(Object? instance) {
    if (instance is ReactterInstance) {
      return instance.stored?.key ?? instance.key;
    }

    return Reactter.find(instance)?.key ?? "${instance.hashCode}";
  }

  /// Returns a combination of the instance key, the event name key,
  /// and the callback key. This optimizes event storage.
  String _getEventKey(
    Object? instance,
    Enum eventName, [
    Function? callback,
  ]) {
    if (callback == null) {
      return "${_getInstanceKey(instance)}.${eventName.hashCode}";
    }

    return "${_getInstanceKey(instance)}.${eventName.hashCode}.${callback.hashCode}";
  }

  Object? _getInstance(Object? instance) {
    return instance is ReactterInstance ? instance.stored?.instance : instance;
  }

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
}
