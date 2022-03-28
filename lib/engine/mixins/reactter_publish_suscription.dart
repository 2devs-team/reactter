mixin ReactterPubSub {
  final List<void Function()> _subscribers = [];

  void subscribe(void Function() subscriber) {
    _subscribers.add(subscriber);
  }

  void unsubscribe(void Function() subscriber) {
    _subscribers.remove(subscriber);
  }

  void publish() {
    for (final _subscriber in _subscribers) {
      _subscriber();
    }
  }
}
