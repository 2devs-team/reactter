part of '../framework.dart';

/// A mixin that helps to manages dependencies
/// and notify when should be updated its dependencies.
@internal
mixin ScopeElementMixin on InheritedElement {
  bool _isFlushDependentsScheduled = false;
  bool _updatedShouldNotify = false;
  final _dependenciesDirty = HashSet<Dependency>();
  final _dependents = HashMap<Element, Object?>();
  final _instancesAndStatesDependencies = HashMap<Object, Set<Dependency>>();
  final _dependentsFlushReady = <Element>{};

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
  Object? getDependencies(Element dependent) {
    return _dependents[dependent] ?? super.getDependencies(dependent);
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    // coverage:ignore-start
    if (aspect is! Dependency) {
      return super.updateDependencies(dependent, aspect);
    }

    var masterDependency = getDependencies(dependent);

    if (masterDependency != null && masterDependency is! MasterDependency) {
      return super.updateDependencies(dependent, aspect);
    }
    // coverage:ignore-end

    _scheduleflushDependents();

    masterDependency = _flushDependent(dependent, masterDependency);

    if (masterDependency is MasterDependency) {
      masterDependency.putDependency(aspect);
    }

    masterDependency ??= aspect.makeMaster();
    _addListener(masterDependency as MasterDependency);

    return setDependencies(dependent, masterDependency);
  }

  @override
  void setDependencies(Element dependent, Object? value) {
    if (value is MasterDependency) {
      _dependents[dependent] = value;
    }

    super.setDependencies(dependent, value);
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    // select can never be used inside `didChangeDependencies`, so if the
    // dependent is already marked as needed build, there is no point
    // in executing the selectors.
    if (dependent.dirty) return;

    final dependency = getDependencies(dependent);
    final dependencies = {
      dependency,
      if (dependency is MasterDependency) ...dependency._selects,
    };

    if (dependencies.any(_dependenciesDirty.contains)) {
      dependent.didChangeDependencies();
      _removeDependencies(dependent);
      _dependenciesDirty.removeAll(dependencies);
    }
  }

  void _addListener(Dependency dependency) {
    if (dependency._instance != null) {
      _addInstanceListener(dependency._instance!, dependency);
    }

    if (dependency._states.isNotEmpty) {
      _addStatesListener(dependency._states, dependency);
    }

    if (dependency is MasterDependency && dependency._selects.isNotEmpty) {
      for (final dependency in dependency._selects) {
        _addListener(dependency);
      }
    }
  }

  void _addInstanceListener(
    Object instance,
    Dependency dependency,
  ) {
    if (!_instancesAndStatesDependencies.containsKey(instance)) {
      Reactter.on(instance, Lifecycle.didUpdate, _markNeedsNotifyDependents);
    }

    _instancesAndStatesDependencies[instance] ??= {};
    _instancesAndStatesDependencies[instance]?.add(dependency);
  }

  void _addStatesListener(
    Set<ReactterState> states,
    Dependency dependency,
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

    final dependencies = _instancesAndStatesDependencies[instanceOrState];

    if (dependencies?.isEmpty ?? true) return;

    final dependenciesDirty = <Dependency>[
      for (final dependency in dependencies!)
        if (dependency is! SelectDependency)
          dependency
        else if (dependency.value != dependency.resolve())
          dependency
    ];

    if (dependenciesDirty.isEmpty) return;

    _dependenciesDirty.addAll(dependenciesDirty);
    dependencies.removeAll(dependenciesDirty);

    if (dependencies.isEmpty) {
      _clearInstanceOrStateDependencies(instanceOrState);
    }

    markNeedsBuild();
  }

  void _scheduleflushDependents() {
    if (_isFlushDependentsScheduled) return;

    _isFlushDependentsScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isFlushDependentsScheduled = false;
      _dependentsFlushReady.clear();
    });
  }

  Object? _flushDependent(Element dependent, Object? dependency) {
    if (_dependentsFlushReady.contains(dependent)) return dependency;

    _dependentsFlushReady.add(dependent);

    if (dependency is! MasterDependency) return dependency;

    _clearDependency(dependency);

    return null;
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

  void _clearDependency(Dependency dependency) {
    if (dependency._instance != null) {
      final dependencies =
          _instancesAndStatesDependencies[dependency._instance];
      dependencies?.remove(dependency);

      if (dependencies?.isEmpty ?? false) {
        _clearInstanceOrStateDependencies(dependency._instance);
      }
    }

    for (final state in dependency._states) {
      final dependenciesOfState = _instancesAndStatesDependencies[state];
      dependenciesOfState?.remove(dependency);

      if (dependenciesOfState?.isEmpty ?? false) {
        _clearInstanceOrStateDependencies(state);
      }
    }

    if (dependency is MasterDependency) {
      for (final select in dependency._selects) {
        _clearDependency(select);
      }
    }
  }

  void _clearInstanceOrStateDependencies(Object? instanceOrState) {
    Reactter.off(
      instanceOrState,
      Lifecycle.didUpdate,
      _markNeedsNotifyDependents,
    );

    _instancesAndStatesDependencies.remove(instanceOrState);
  }
}
