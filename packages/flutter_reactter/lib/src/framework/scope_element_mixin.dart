part of '../framework.dart';

/// A mixin that helps to manages dependencies
/// and notify when should be updated its dependencies.
@internal
mixin ScopeElementMixin on InheritedElement {
  final _dependents = HashMap<Element, MasterDependency>();
  final _dependentsFlushReady = <Element>{};
  bool _isFlushDependentsScheduled = false;
  bool _updatedShouldNotify = false;
  bool _isMarkNeedsBuild = false;

  bool get hasDirtyDependencies =>
      _isMarkNeedsBuild || _dependents.values.any((dep) => dep.isDirty);

  @override
  void update(InheritedWidget newWidget) {
    _updatedShouldNotify = true;
    super.update(newWidget);
    _updatedShouldNotify = false;
  }

  @override
  void updated(InheritedWidget oldWidget) {
    if (_updatedShouldNotify) {
      // If the widget tree is updated, we need to reset the state
      // to avoid memory leaks.
      _resetState();
      notifyClients(oldWidget);
      return;
    }

    super.updated(oldWidget); // coverage:ignore-line
  }

  @override
  void unmount() {
    _resetState();
    return super.unmount();
  }

  /// Returns the value of the dependency of the dependent.
  /// If a MasterDepndency is stored in this scope, it will be returned.
  /// Otherwise, it will return the value of the dependency of the dependent in
  /// the parent scope.
  @override
  Object? getDependencies(Element dependent) {
    return _dependents[dependent] ?? super.getDependencies(dependent);
  }

  /// Sets the value of the dependency of the dependent.
  /// If a MasterDepndency is stored in this scope, it will be set.
  /// Otherwise, it will set the value of the dependency of the dependent in
  /// the parent scope.
  @override
  void setDependencies(Element dependent, Object? value) {
    if (value is MasterDependency) _dependents[dependent] = value;

    super.setDependencies(dependent, value);
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    // If the aspect is not a Dependency or if the widget tree is marked as
    // needing build, we can skip the update of the dependencies.
    if (aspect is! Dependency || _isMarkNeedsBuild) {
      return super.updateDependencies(dependent, aspect);
    }

    var dependency = getDependencies(dependent);

    // If no MasterDependency is stored, we can skip the update of the dependencies.
    if (dependency != null && dependency is! MasterDependency) {
      return super
          .updateDependencies(dependent, aspect); // coverage:ignore-line
    }

    assert(dependency is MasterDependency?);

    MasterDependency? masterDependency = dependency as MasterDependency?;

    // Flush the dependent element and dispose of the dependency if it exists.
    masterDependency = _flushDependent(dependent, masterDependency);

    // If the dependency is a MasterDependency, add the aspect to it.
    if (masterDependency is MasterDependency) {
      masterDependency.putDependency(aspect);
    }

    // If the dependency is not a MasterDependency, create a new MasterDependency.
    masterDependency ??= aspect.toMaster();

    if (masterDependency.isDirty) {
      markNeedsBuild(); // coverage:ignore-line
    } else {
      masterDependency.listen(markNeedsBuild);
    }

    return setDependencies(dependent, masterDependency);
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    // if the dependent is already marked as needed build, there is no point
    // in executing the evaluations about the dirty dependencies, because
    // the dependent will be rebuild anyway.
    if (dependent.dirty) return;

    if (!_isMarkNeedsBuild) return super.notifyDependent(oldWidget, dependent);

    final dependency = getDependencies(dependent);

    if (dependency is! MasterDependency) return;

    final isDirty =
        dependency.isDirty || dependency._selects.any((dep) => dep.isDirty);

    if (!isDirty) return;

    _removeDependencies(dependent);
    _isMarkNeedsBuild = false;
    dependent.didChangeDependencies();
  }

  /// Schedules a callback to flush dependents after the current frame.
  void _scheduleflushDependents() {
    if (_isFlushDependentsScheduled) return;

    _isFlushDependentsScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isFlushDependentsScheduled = false;
      _dependentsFlushReady.clear();
    });
  }

  /// Flushes the dependent element and disposes of the dependency if it exists.
  ///
  /// This method schedules the flushing of dependents and ensures that the
  /// dependent element is marked as ready for flushing. If the dependent element
  /// is already marked as ready, it returns the existing dependency.
  ///
  /// If the dependency is of type [MasterDependency], it is disposed of.
  ///
  /// Returns `null` after disposing of the dependency.
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

  @override
  void markNeedsBuild() {
    if (_isMarkNeedsBuild) return;

    _isMarkNeedsBuild = true;
    try {
      super.markNeedsBuild();
    } catch (error) {
      if (error is! AssertionError) rethrow;

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => super.markNeedsBuild(),
      );
    }
  }

  void _removeDependencies(Element dependent) {
    setDependencies(dependent, null);
    _dependents.remove(dependent)?.dispose();
  }

  void _resetState() {
    _disposeDependencies();
    _dependentsFlushReady.clear();
    _isFlushDependentsScheduled = false;
    _updatedShouldNotify = false;
    _isMarkNeedsBuild = false;
  }

  void _disposeDependencies() {
    final dependencies = _dependents.values;

    for (final dependency in dependencies) {
      dependency.dispose();
    }

    _dependents.clear();
  }
}
