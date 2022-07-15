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
