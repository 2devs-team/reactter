enum PubSubEvent { willUpdate, didUpdate }

/// Provides a Publish and Subscribe pattern manager
mixin ReactterPubSub {
  /// Stores all subscribe callbacks
  final Map<PubSubEvent, List<Function>> _subscribers = {};

  /// Save a subscribe callback
  void subscribe(PubSubEvent event, Function subscriber) {
    _subscribers[event] ??= [];
    _subscribers[event]?.add(subscriber);
  }

  /// Remove a subscribe callback and invoke unsubscribe callback
  void unsubscribe(PubSubEvent event, Function subscriber) {
    _subscribers[event]?.remove(subscriber);
  }

  /// First, invokes the subscribed callbacks of the willUpdate event.
  /// Second, invokes the callback entered by parameter.
  /// And finally, invokes the subscribed callbacks of the didUpdate event.
  void update([Function? callback]) {
    final willUpdateSubscribers = _subscribers[PubSubEvent.willUpdate] ?? [];
    final didUpdateSubscribers = _subscribers[PubSubEvent.didUpdate] ?? [];

    for (var i = 0; i < willUpdateSubscribers.length; i++) {
      willUpdateSubscribers[i].call();
    }

    callback?.call();

    for (var i = 0; i < didUpdateSubscribers.length; i++) {
      didUpdateSubscribers[i].call();
    }
  }
}
