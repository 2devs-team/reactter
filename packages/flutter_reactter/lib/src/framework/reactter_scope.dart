part of '../framework.dart';

/// A mixin that helps to manages dependencies
/// and notify when should be updated its dependencies.
@internal
mixin ReactterScopeElementMixin on InheritedElement {
  bool _updatedShouldNotify = false;
  final HashSet<Object> _instanceOrStatesDirty = HashSet();
  HashSet<Object> get instanceOrStatesDirty => _instanceOrStatesDirty;
  final HashMap<Element, Object?> _dependents = HashMap<Element, Object?>();

  @override
  void update(InheritedWidget newWidget) {
    _updatedShouldNotify = true;
    super.update(newWidget);
    _updatedShouldNotify = false;
  }

  @override
  void updated(InheritedWidget oldWidget) {
    super.updated(oldWidget);
    if (_updatedShouldNotify) {
      notifyClients(oldWidget);
    }
  }

  @override
  void unmount() {
    _removeDependents();
    _instanceOrStatesDirty.clear();
    return super.unmount();
  }

  @override
  Object? getDependencies(Element dependent) => _dependents[dependent];

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    if (aspect is! ReactterDependency) {
      return;
    }

    final dependencyOrigin = getDependencies(dependent);

    if (dependencyOrigin != null && dependencyOrigin is! ReactterDependency) {
      return;
    }

    final dependency = (dependencyOrigin ?? aspect) as ReactterDependency;

    if (dependencyOrigin == null) {
      dependency._addListener(_markNeedsNotifyDependents);
      return setDependencies(dependent, dependency);
    }

    if (aspect._instance != null) {
      dependency._addInstanceAndListener(
        aspect._instance,
        _markNeedsNotifyDependents,
      );
      return setDependencies(dependent, dependency);
    }

    if (aspect._states != null) {
      dependency._addStatesAndListener(
        aspect._states!,
        _markNeedsNotifyDependents,
      );
      return setDependencies(dependent, dependency);
    }
  }

  @override
  void setDependencies(Element dependent, Object? value) {
    if (value is ReactterDependency) {
      _dependents[dependent] = value;
    }

    super.setDependencies(dependent, value);
  }

  @override
  void notifyClients(InheritedWidget oldWidget) {
    super.notifyClients(oldWidget);
    _instanceOrStatesDirty.clear();
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    // select can never be used inside `didChangeDependencies`, so if the
    // dependent is already marked as needed build, there is no point
    // in executing the selectors.
    if (dependent.dirty) return;

    final dependency = getDependencies(dependent);

    if (dependency is! ReactterDependency ||
        _hasInstanceOrStatesDirty(dependency)) {
      dependent.didChangeDependencies();
      _removeDependencies(dependent);
    }
  }

  bool _hasInstanceOrStatesDirty(ReactterDependency dependency) {
    return _instanceOrStatesDirty.contains(dependency._instance) ||
        dependency._states?.any(_instanceOrStatesDirty.contains) == true;
  }

  void _markNeedsNotifyDependents(Object? instanceOrState, _) {
    assert(instanceOrState != null);
    _instanceOrStatesDirty.add(instanceOrState!);
    markNeedsBuild();
  }

  void _removeDependents() {
    for (final dependent in _dependents.keys) {
      _removeDependenciesListener(dependent);
    }

    _dependents.clear();
  }

  void _removeDependencies(Element dependent) {
    _removeDependenciesListener(dependent);
    setDependencies(dependent, null);
    _dependents.remove(dependent);
  }

  void _removeDependenciesListener(Element dependent) {
    final dependency = getDependencies(dependent);

    if (dependency is! ReactterDependency) return;

    dependency._removeListener(_markNeedsNotifyDependents);
  }
}
