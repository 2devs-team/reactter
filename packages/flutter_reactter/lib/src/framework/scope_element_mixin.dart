part of '../framework.dart';

/// A mixin that helps to manages dependencies
/// and notify when should be updated its dependencies.
@internal
mixin ScopeElementMixin on InheritedElement {
  final _dependents = HashMap<Element, Object?>();
  final _dependentsFlushReady = <Element>{};
  final _dependenciesDirty = HashSet<Dependency>();

  bool get hasDependenciesDirty => _dependenciesDirty.isNotEmpty;
  bool _isFlushDependentsScheduled = false;
  bool _updatedShouldNotify = false;
  bool _isMarkNeedsBuild = false;

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
    _disposeDependencies();
    return super.unmount();
  }

  @override
  Object? getDependencies(Element dependent) {
    return _dependents[dependent] ?? super.getDependencies(dependent);
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    // coverage:ignore-start
    if (aspect is! Dependency || _isMarkNeedsBuild) {
      return super.updateDependencies(dependent, aspect);
    }

    var dependency = getDependencies(dependent);

    if (dependency != null && dependency is! MasterDependency) {
      return super.updateDependencies(dependent, aspect);
    }
    // coverage:ignore-end

    assert(dependency is MasterDependency || dependency == null);

    var masterDependency = dependency is MasterDependency ? dependency : null;

    masterDependency = _flushDependent(dependent, masterDependency);

    if (masterDependency is MasterDependency) {
      masterDependency.putDependency(aspect);
    }

    masterDependency ??= aspect.toMaster();

    if (masterDependency.isDirty) {
      markNeedsNotifyDependents(masterDependency, null);
    } else {
      masterDependency.listen(markNeedsNotifyDependents);
    }

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

    if (!dependencies.any(_dependenciesDirty.contains)) return;

    dependent.didChangeDependencies();
    _removeDependencies(dependent);
    _dependenciesDirty.removeAll(dependencies);
    _isMarkNeedsBuild = false;
  }

  void _scheduleflushDependents() {
    if (_isFlushDependentsScheduled) return;

    _isFlushDependentsScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isFlushDependentsScheduled = false;
      _dependentsFlushReady.clear();
    });
  }

  MasterDependency<T>? _flushDependent<T>(
    Element dependent,
    MasterDependency<T>? dependency,
  ) {
    _scheduleflushDependents();

    if (_dependentsFlushReady.contains(dependent)) return dependency;

    _dependentsFlushReady.add(dependent);

    if (dependency is MasterDependency<T>) dependency.dispose();

    return null;
  }

  void markNeedsNotifyDependents(
    Dependency dependency,
    dynamic instanceOrState,
  ) {
    _dependenciesDirty.add(dependency);
    markNeedsBuild();
  }

  @override
  void markNeedsBuild() {
    if (_isMarkNeedsBuild) return;

    _isMarkNeedsBuild = true;
    super.markNeedsBuild();
  }

  void _removeDependencies(Element dependent) {
    setDependencies(dependent, null);
    _dependents.remove(dependent);
  }

  void _disposeDependencies() {
    final dependencies = _dependents.values;

    for (final dependency in dependencies) {
      if (dependency is Dependency) dependency.dispose();
    }

    _dependents.clear();
    _dependenciesDirty.clear();
  }
}
