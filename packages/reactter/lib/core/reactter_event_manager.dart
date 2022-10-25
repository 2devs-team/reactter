// ignore_for_file: constant_identifier_names, avoid_print
part of '../core.dart';

/// A event manager
mixin ReactterEventManager {
  /// Event's store.
  HashMap<String, HashMap<Enum, HashSet<Function>>> _events = HashMap();

  /// Puts on to listen [eventName] event.
  ///
  /// When the event is [emit]ted, the [callback] is called.
  void on<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    if (instance is ReactterNotifyManager) {
      instance._listenersCount += 1;
    }

    final _eventKey = _getEventKey(instance);

    _events[_eventKey] ??= HashMap();
    _events[_eventKey]?[eventName] ??= HashSet();
    _events[_eventKey]?[eventName]?.add(callback);
  }

  /// Puts on to listen [eventName] event only once.
  ///
  /// When the event is [emit]ted, the [callback] is called
  /// and after removes [eventName] event.
  void one<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    void _oneCallback(inst, param) {
      callback(inst, param);

      off<T, P>(instance, eventName, callback);
      off<T, P>(instance, eventName, _oneCallback);
    }

    on<T, P>(instance, eventName, _oneCallback);
  }

  /// Removes the [callback] of [eventName] event.
  void off<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    if (instance is ReactterNotifyManager) {
      instance._listenersCount -= 1;
    }

    final _eventKey = _getEventKey(instance);

    _events[_eventKey]?[eventName]?.remove(callback);

    if (_events[_eventKey]?[eventName]?.isEmpty ?? false) {
      _events[_eventKey]?.remove(eventName);
    }

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
    final _callbacks = _getCallbacks(instance, eventName);

    if (_callbacks == null) return;

    final callbacks = {..._callbacks};

    for (var callback in callbacks) {
      callback(_getInstance(instance), param);
    }
  }

  Future<void> emitAsync(
    Object? instance,
    Enum eventName, [
    dynamic param,
  ]) async {
    final _callbacks = _getCallbacks(instance, eventName);

    if (_callbacks == null) return;

    final callbacks = {..._callbacks};

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
    _events.remove(_getEventKey(instance));
  }

  String _getEventKey(Object? instance) {
    if (instance is ReactterInstance) {
      return instance.stored?.key ?? instance.key;
    }

    final reactterInstance = Reactter.find(instance);
    return reactterInstance?.key ?? instance.hashCode.toString();
  }

  Object? _getInstance(Object? instance) =>
      instance is ReactterInstance ? instance.stored?.instance : instance;

  HashSet<Function>? _getCallbacks(
    Object? instance,
    Enum eventName,
  ) {
    if (_events.length == 0) {
      return null;
    }

    final events = _events[_getEventKey(instance)];

    if (events == null || events.length == 0) {
      return null;
    }

    final eventCallbacks = events[eventName];

    if (eventCallbacks == null || eventCallbacks.length == 0) {
      return null;
    }

    return eventCallbacks;
  }
}
