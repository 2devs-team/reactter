enum EVENT_TYPE { awake, willMount, didMount, willUnmount }
mixin ReactterLifeCycle {
  final Map<EVENT_TYPE, List<Function>> _events = {};

  void executeEvent(EVENT_TYPE type) {
    for (final callback in _events[type] ?? []) {
      callback();
    }
  }

  /// Executes when the instance starts building.
  void Function() onAwake(Function callback) {
    _events[EVENT_TYPE.awake] ??= [];
    _events[EVENT_TYPE.awake]?.add(callback);

    return () => _events[EVENT_TYPE.awake]?.remove(callback);
  }

  /// Executes before the dependency widget will mount in the tree.
  void Function() onWillMount(Function callback) {
    _events[EVENT_TYPE.willMount] ??= [];
    _events[EVENT_TYPE.willMount]?.add(callback);

    return () => _events[EVENT_TYPE.willMount]?.remove(callback);
  }

  /// Executes after the dependency widget did mount in the tree.
  void Function() onDidMount(Function callback) {
    _events[EVENT_TYPE.didMount] ??= [];
    _events[EVENT_TYPE.didMount]?.add(callback);

    return () => _events[EVENT_TYPE.didMount]?.remove(callback);
  }

  /// Executes when the widget removes from the tree.
  void Function() onWillUnmount(Function callback) {
    _events[EVENT_TYPE.willUnmount] ??= [];
    _events[EVENT_TYPE.willUnmount]?.add(callback);

    return () => _events[EVENT_TYPE.willUnmount]?.remove(callback);
  }
}
