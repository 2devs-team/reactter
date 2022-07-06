part of '../hooks.dart';

class UseEvent<T extends Object?> {
  static final HashMap<Object?, HashMap<Enum, Set<Function>>> _subscribers =
      HashMap();

  Object? _instance = null;

  Object? get instance => _instance is ReactterInstance
      ? Reactter.factory.instances.lookup(_instance)?.instance
      : _instance;

  ReactterInstance? get instanceManager => _instance is ReactterInstance
      ? (_instance as ReactterInstance)
      : Reactter.find(_instance);

  UseEvent([String? _id]) : _instance = ReactterInstance<T?>(_id);

  UseEvent.withInstance(T instance)
      : assert(instance != null),
        _instance = instance;

  void on<P>(Enum eventName, CallbackEvent<T, P> callback) {
    UseEvent._subscribers[_instance] ??= HashMap();
    UseEvent._subscribers[_instance]?[eventName] ??= HashSet();
    UseEvent._subscribers[_instance]?[eventName]?.add(callback);
  }

  void one<P>(Enum eventName, CallbackEvent<T, P> callback) {
    void _oneCallback(inst, param) {
      callback(inst, param);

      off(eventName, callback);
      off(eventName, _oneCallback);
    }

    on<P>(eventName, _oneCallback);
  }

  void off<P>(Enum eventName, CallbackEvent<T, P> callback) {
    UseEvent._subscribers[_instance]?[eventName]?.remove(callback);

    if (UseEvent._subscribers[_instance]?[eventName]?.isEmpty ?? false) {
      UseEvent._subscribers[_instance]?.remove(eventName);
    }

    if (UseEvent._subscribers[_instance]?.isEmpty ?? false) {
      UseEvent._subscribers.remove(_instance);
    }
  }

  void trigger(Enum eventName, [dynamic param]) {
    final callbacks = HashSet()
      ..addAll(
        UseEvent._subscribers[instance]?[eventName] ?? {},
      )
      ..addAll(
        UseEvent._subscribers[instanceManager]?[eventName] ?? {},
      );

    for (var callback in callbacks) {
      callback(instance, param);
    }
  }

  void dispose() {
    UseEvent._subscribers
      ..remove(instance)
      ..remove(instanceManager);

    _instance = null;
  }
}
