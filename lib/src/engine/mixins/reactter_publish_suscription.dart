/// Inject listeners to state
mixin ReactterPubSub {
  final List<void Function()> _subscribers = [];

  void subscribe(void Function() subscriber) {
    _subscribers.add(subscriber);
  }

  void unsubscribe(void Function() subscriber) {
    _subscribers.remove(subscriber);
  }

  /// Rebuild everytime is called.
  ///
  /// Here is when [markAsNeedRebuild] is set when the instance is created.
  void publish() {
    for (final _subscriber in _subscribers) {
      _subscriber();
    }
  }
}
