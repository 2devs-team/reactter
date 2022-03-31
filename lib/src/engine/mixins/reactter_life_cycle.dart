mixin ReactterLifeCycle {
  /// Executes when the instance starts building.
  void awake() {}

  /// Executes before the dependency widget will mount in the tree.
  void willMount() {}

  /// Executes after the dependency widget did mount in the tree.
  void didMount() {}

  /// Executes when the widget removes from the tree.
  void willUnmount() {}
}
