part of '../widgets.dart';

/// A generic implementation for [ReactterScope]
class ReactterScopeInherited extends InheritedWidget {
  const ReactterScopeInherited({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  @override
  ReactterScopeInheritedElement createElement() {
    return ReactterScopeInheritedElement(this);
  }
}

/// [ReactterScopeInherited]'s Element
class ReactterScopeInheritedElement extends InheritedElement {
  bool _updatedShouldNotify = false;
  final List<Function> _unsubscribersDependencies = [];

  ReactterScopeInheritedElement(InheritedWidget widget) : super(widget);

  @override
  Widget build() {
    _removeDependencies();
    notifyClients(super.widget as InheritedWidget);

    return super.build();
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final dependencies = getDependencies(dependent);
    // once subscribed to everything once, it always stays subscribed to everything.
    if (dependencies != null && dependencies is! _Dependency) {
      return;
    }

    if (aspect is SelectorAspect) {
      final selectorDependency = (dependencies ?? _Dependency()) as _Dependency;

      if (selectorDependency.shouldClearSelectors) {
        selectorDependency.shouldClearSelectors = false;
        selectorDependency.selectors.clear();
      }
      if (selectorDependency.shouldClearMutationScheduled == false) {
        selectorDependency.shouldClearMutationScheduled = true;
        Future.microtask(() {
          selectorDependency
            ..shouldClearMutationScheduled = false
            ..shouldClearSelectors = true;
        });
      }
      selectorDependency.selectors.add(aspect);
      setDependencies(dependent, selectorDependency);
    } else {
      // Subscribes to everything.
      setDependencies(dependent, const Object());
    }
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    final dependencies = getDependencies(dependent);

    var shouldNotify = false;
    if (dependencies != null) {
      if (dependencies is _Dependency) {
        // select can never be used inside [didChangeDependencies], so if the
        // dependent is already marked as needed build, there is no point
        // in executing the selectors.
        if (dependent.dirty) {
          return;
        }

        for (final updateShouldNotify in dependencies.selectors) {
          try {
            shouldNotify = updateShouldNotify(this);
          } finally {}
          if (shouldNotify) {
            break;
          }
        }
      } else {
        shouldNotify = true;
      }
    }

    if (shouldNotify) {
      dependent.didChangeDependencies();
    }
  }

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
    _removeDependencies();

    return super.unmount();
  }

  void dependOnHooks(List<ReactterHook> hooks) {
    for (int i = 0; i < hooks.length; i++) {
      final hook = hooks[i];

      void _onDidUpdate(_, __) => markNeedsBuild();

      UseEvent.withInstance(hook).on(Lifecycle.didUpdate, _onDidUpdate);

      _unsubscribersDependencies.add(
        () =>
            UseEvent.withInstance(hook).off(Lifecycle.didUpdate, _onDidUpdate),
      );
    }
  }

  void dependOnInstance(ReactterContext instance) {
    void _onDidUpdate(_, __) => markNeedsBuild();

    UseEvent.withInstance(instance).on(Lifecycle.didUpdate, _onDidUpdate);

    _unsubscribersDependencies.add(
      () => UseEvent.withInstance(instance)
          .off(Lifecycle.didUpdate, _onDidUpdate),
    );
  }

  /// Unsubscribes dependencies
  void _removeDependencies() {
    for (var i = 0; i < _unsubscribersDependencies.length; i++) {
      _unsubscribersDependencies[i].call();
    }

    _unsubscribersDependencies.clear();
  }
}

class _Dependency<T> {
  bool shouldClearSelectors = false;
  bool shouldClearMutationScheduled = false;
  final selectors = <SelectorAspect<T>>[];
}
