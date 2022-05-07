import 'package:flutter/widgets.dart';
import 'reactter_inherit_provider_scope.dart';
import '../core/mixins/reactter_publish_suscription.dart';
import '../core/reactter_types.dart';

class _Dependency<T> {
  bool shouldClearSelectors = false;
  bool shouldClearMutationScheduled = false;
  final selectors = <SelectorAspect<T>>[];
}

/// Main element who it is in charge to make a rebuild in the view.
class ReactterInheritedProviderScopeElement extends InheritedElement {
  ReactterInheritedProviderScopeElement(ReactterInheritedProviderScope widget)
      : super(widget);

  bool _updatedShouldNotify = false;

  final List<ReactterPubSub> _dependencies = [];

  @override
  ReactterInheritedProviderScope get widget =>
      super.widget as ReactterInheritedProviderScope;

  /// Executes lyfecicle [willMount] and [didMount] method before and after render respectively.
  @override
  void mount(Element? parent, dynamic newSlot) {
    widget.owner.willMount();

    super.mount(parent, newSlot);

    widget.owner.didMount();
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
  void update(ReactterInheritedProviderScope newWidget) {
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
  Widget build() {
    notifyClients(widget);
    return super.build();
  }

  @override
  void unmount() {
    widget.owner.willUnmount();
    super.unmount();
  }

  /// Adds instance to [_dependencies] and subscribes [markNeedsBuild]
  void dependOnInstance(ReactterPubSub instance) {
    instance.subscribe(markNeedsBuild);
    _dependencies.add(instance);
  }

  /// Removes instance from [_dependencies] and unsubscribes [markNeedsBuild]
  void removeDependencies() {
    for (var i = 0; i < _dependencies.length; i++) {
      final _isntance = _dependencies[i];
      _isntance.unsubscribe(markNeedsBuild);
    }

    _dependencies.clear();
  }
}
