part of '../core.dart';

class ReactterSubscribersManager<T extends Enum> {
  /// Stores all subscribe callbacks
  final HashMap<T, List<Function>> _subscribers = HashMap();

  /// Save a subscribe callback
  void subscribe(T event, Function subscriber) {
    _subscribers[event] ??= [];
    _subscribers[event]?.add(subscriber);
  }

  /// Remove a subscribe callback and invoke unsubscribe callback
  void unsubscribe(T event, Function subscriber) {
    _subscribers[event]?.remove(subscriber);
  }

  /// Invokes the subscribed callbacks of event given
  void publish(T event) {
    final subscribersEvent = _subscribers[event] ?? [];

    for (var i = 0; i < subscribersEvent.length; i++) {
      subscribersEvent[i].call();
    }
  }
}
