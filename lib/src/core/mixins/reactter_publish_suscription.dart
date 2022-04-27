/// Inject listeners to state
mixin ReactterPubSub {
  final List<Function> _subscribers = [];
  final Map<Function, Function> _unsubscribers = {};

  void subscribe(Function subscriber) {
    _subscribers.add(subscriber);
  }

  void unsubscribe(Function subscriber) {
    _unsubscribers[subscriber]?.call();
    _subscribers.remove(subscriber);
    _unsubscribers.remove(subscriber);
  }

  /// Rebuild everytime is called.
  ///
  /// Here is when [markAsNeedRebuild] is set when the instance is created.
  void publish() {
    for (final _subscriber in _subscribers) {
      _unsubscribers[_subscriber]?.call();

      final _unsubscriber = _subscriber();

      if (_unsubscriber is Function) {
        _unsubscribers[_subscriber] = _unsubscriber;
      }
    }
  }
}
