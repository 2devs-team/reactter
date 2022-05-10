enum LifeCycleEvent { willMount, didMount, willUpdate, didUpdate, willUnmount }

/// Provides a life cycle manager
mixin ReactterLifeCycle {
  /// Stores all events of life cycle with the callbacks
  final Map<LifeCycleEvent, List<Function>> _events = {};

  /// Fires the event of type and executes the callbacks
  void executeEvent(LifeCycleEvent type) {
    for (final callback in _events[type] ?? []) {
      callback();
    }
  }

  /// Save a callback on [willMount] event.
  ///
  /// This event will execute before the dependency widget will mount in the tree.
  void Function() onWillMount(Function callback) =>
      _onLifeCycleEvent(LifeCycleEvent.willMount, callback);

  /// Save a callback on [didMount] event.
  ///
  /// This event will execute after the dependency widget did mount in the tree.
  void Function() onDidMount(Function callback) =>
      _onLifeCycleEvent(LifeCycleEvent.didMount, callback);

  /// Save a callback on [willUpdate] event.
  ///
  /// This event will execute before the dependency widget will update in the tree.
  void Function() onWillUpdate(Function callback) =>
      _onLifeCycleEvent(LifeCycleEvent.willUpdate, callback);

  /// Save a callback on [didUpdate] event.
  ///
  /// This event will execute after the dependency widget did update in the tree.
  void Function() onDidUpdate(Function callback) =>
      _onLifeCycleEvent(LifeCycleEvent.didUpdate, callback);

  /// Save a callback on [willUnmount] event.
  ///
  /// This event will execute when the widget removes from the tree.
  void Function() onWillUnmount(Function callback) =>
      _onLifeCycleEvent(LifeCycleEvent.willUnmount, callback);

  _onLifeCycleEvent(LifeCycleEvent event, Function callback) {
    _events[event] ??= [];
    _events[event]?.add(callback);

    return () => _events[event]?.remove(callback);
  }
}
