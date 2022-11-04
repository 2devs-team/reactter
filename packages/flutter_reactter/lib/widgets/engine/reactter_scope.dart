part of '../../widgets.dart';

mixin ReactterScopeElementMixin on InheritedElement {
  bool _updatedShouldNotify = false;
  final HashSet<Object> _instanceOrStatesDirty = HashSet();
  final HashSet<Element> _dependents = HashSet();

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
  void updateDependencies(Element dependent, Object? aspect) {
    if (aspect is! ReactterDependency) {
      return;
    }

    final dependenciesCurrent = getDependencies(dependent);

    if (dependenciesCurrent != null &&
        dependenciesCurrent is! Set<ReactterDependency>) {
      return;
    }

    final dependencies = (dependenciesCurrent ?? <ReactterDependency>{})
        as Set<ReactterDependency>;
    final dependencyFound = dependencies.lookup(aspect);

    if (dependencyFound == null) {
      dependencies.add(aspect);
      aspect._addListener(_markNeedsNotifyDependents);
      return setDependencies(dependent, dependencies);
    }

    if (aspect._instance != null) {
      dependencyFound._addInstanceAndListener(
        aspect._instance,
        _markNeedsNotifyDependents,
      );
      return setDependencies(dependent, dependencies);
    }

    if (aspect._states != null) {
      dependencyFound._addStatesAndListener(
        aspect._states!,
        _markNeedsNotifyDependents,
      );
      return setDependencies(dependent, dependencies);
    }
  }

  @override
  void setDependencies(Element dependent, Object? value) {
    if (value is Set<ReactterDependency>) {
      _dependents.add(dependent);
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
    var shouldNotify = false;
    final dependencies = getDependencies(dependent);

    if (dependencies != null) {
      if (dependencies is Set<ReactterDependency>) {
        // select can never be used inside `didChangeDependencies`, so if the
        // dependent is already marked as needed build, there is no point
        // in executing the selectors.
        if (dependent.dirty) {
          return;
        }

        forDependecies:
        for (final dependency in dependencies) {
          shouldNotify = _instanceOrStatesDirty.contains(dependency._instance);

          if (shouldNotify) break forDependecies;

          if (dependency._states != null) {
            for (final state in dependency._states!) {
              shouldNotify = _instanceOrStatesDirty.contains(state);

              if (shouldNotify) break forDependecies;
            }
          }
        }
      } else {
        shouldNotify = true;
      }
    }

    if (shouldNotify) {
      dependent.didChangeDependencies();
      _removeDependencies(dependent);
    }
  }

  void _markNeedsNotifyDependents(Object? instanceOrState, _) {
    assert(instanceOrState != null);
    _instanceOrStatesDirty.add(instanceOrState!);
    markNeedsBuild();
  }

  void _removeDependents() {
    for (final dependent in _dependents) {
      _removeDependencies(dependent);
    }
  }

  void _removeDependencies(Element dependent) {
    final dependencies = getDependencies(dependent);

    if (dependencies is! Set<ReactterDependency>) return;

    for (final dependency in dependencies) {
      dependency._removeListener(_markNeedsNotifyDependents);
    }

    super.setDependencies(dependent, null);
    _dependents.remove(dependent);
  }
}