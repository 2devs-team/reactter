part of '../framework.dart';

/// A mixin that helps to manages dependencies
/// and notify when should be updated its dependencies.
@internal
mixin ReactterScopeElementMixin on InheritedElement {
  bool _updatedShouldNotify = false;
  final _dependenciesDirty = HashSet<ReactterDependency>();
  final _dependents = HashMap<Element, Object?>();
  final _instancesAndStatesDependencies =
      HashMap<Object, Set<ReactterDependency>>();

  bool get hasDependenciesDirty => _dependenciesDirty.isNotEmpty;

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
    _dependents.clear();
    _dependenciesDirty.clear();
    _removeListeners();
    return super.unmount();
  }

  @override
  Object? getDependencies(Element dependent) =>
      _dependents[dependent] ?? super.getDependencies(dependent);

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    if (aspect is! ReactterDependency) {
      return super.updateDependencies(dependent, aspect);
    }

    final dependencyOrigin = getDependencies(dependent);

    if (dependencyOrigin != null &&
        dependencyOrigin is! ReactterMasterDependency) {
      return super.updateDependencies(dependent, aspect);
    }

    if (dependencyOrigin is ReactterMasterDependency) {
      dependencyOrigin.putDependency(aspect);
    }

    final storeDependency =
        (dependencyOrigin ?? aspect.makeMaster()) as ReactterMasterDependency;

    _addListener(storeDependency);
    return setDependencies(dependent, storeDependency);
  }

  @override
  void setDependencies(Element dependent, Object? value) {
    if (value is ReactterMasterDependency) {
      _dependents[dependent] = value;
    }

    super.setDependencies(dependent, value);
  }

  @override
  void notifyClients(InheritedWidget oldWidget) {
    super.notifyClients(oldWidget);
    _dependenciesDirty.clear();
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    // select can never be used inside `didChangeDependencies`, so if the
    // dependent is already marked as needed build, there is no point
    // in executing the selectors.
    if (dependent.dirty) return;

    final dependency = getDependencies(dependent);

    if (_dependenciesDirty.contains(dependency)) {
      dependent.didChangeDependencies();
      _removeDependencies(dependent);
    }
  }

  void _addListener(ReactterMasterDependency dependency) {
    if (dependency._instance != null) {
      _addInstanceListener(dependency._instance!, dependency);
    }

    if (dependency._states.isNotEmpty) {
      _addStateListener(dependency._states, dependency);
    }
  }

  void _addInstanceListener(
    Object instance,
    ReactterDependency dependency,
  ) {
    if (!_instancesAndStatesDependencies.containsKey(instance)) {
      Reactter.on(instance, Lifecycle.didUpdate, _markNeedsNotifyDependents);
    }

    _instancesAndStatesDependencies[instance] ??= {};
    _instancesAndStatesDependencies[instance]?.add(dependency);
  }

  void _addStateListener(
    Set<ReactterState> states,
    ReactterDependency dependency,
  ) {
    for (final state in states) {
      if (!_instancesAndStatesDependencies.containsKey(state)) {
        Reactter.on(state, Lifecycle.didUpdate, _markNeedsNotifyDependents);
      }

      _instancesAndStatesDependencies[state] ??= {};
      _instancesAndStatesDependencies[state]?.add(dependency);
    }
  }

  void _markNeedsNotifyDependents(Object? instanceOrState, _) {
    assert(instanceOrState != null);

    Reactter.off(
      instanceOrState,
      Lifecycle.didUpdate,
      _markNeedsNotifyDependents,
    );

    _dependenciesDirty
        .addAll(_instancesAndStatesDependencies[instanceOrState]!);
    _instancesAndStatesDependencies.remove(instanceOrState);

    if (instanceOrState is UseWhen) {
      Future.microtask(() => instanceOrState.dispose());
    }

    markNeedsBuild();
  }

  void _removeDependencies(Element dependent) {
    setDependencies(dependent, null);
    _dependents.remove(dependent);
  }

  void _removeListeners() {
    for (final instancesOrStates in _instancesAndStatesDependencies.keys) {
      Reactter.off(
        instancesOrStates,
        Lifecycle.didUpdate,
        _markNeedsNotifyDependents,
      );
    }

    _instancesAndStatesDependencies.clear();
  }
}
