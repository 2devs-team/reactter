// ignore_for_file: invalid_use_of_protected_member, prefer_void_to_null

part of '../widgets.dart';

class ReactterScopeInherited<T extends ReactterContext?, Id extends String?>
    extends InheritedWidget {
  const ReactterScopeInherited({
    Key? key,
    required this.owner,
    required Widget child,
  }) : super(key: key, child: child);

  final ReactterProvider owner;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  @override
  ReactterScopeInheritedElement createElement() {
    return ReactterScopeInheritedElement<T, Id>(this);
  }
}

enum InheritedElementStatus { mount }

class ReactterScopeInheritedElement<T extends ReactterContext?,
    Id extends String?> extends InheritedElement {
  bool _updatedShouldNotify = false;
  T? _instance;
  bool _isRoot = false;
  final List<Function> _unsubscribersDependencies = [];
  Map<ReactterInstance, ReactterScopeInheritedElement<T, Id>>?
      _ancestorScopeInheritedElement;
  final _subscribersManager =
      ReactterSubscribersManager<InheritedElementStatus>();

  ReactterScopeInheritedElement(
    ReactterScopeInherited widget,
  ) : super(widget) {
    if (widget.owner._init) {
      _createInstance();
    }
  }

  @override
  ReactterScopeInherited get widget => super.widget as ReactterScopeInherited;

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty('id', widget.owner._id, showName: true),
    );
    properties.add(
      FlagProperty(
        'isRoot',
        value: _isRoot,
        ifTrue: 'true',
        ifFalse: 'false',
        showName: true,
      ),
    );
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    if (!widget.owner._init) {
      _createInstance();
    }

    _subscribersManager.publish(InheritedElementStatus.mount);
    _updateAncestorScopeInheritedElement(parent);

    if (_isRoot) {
      UseEvent.withInstance(_instance).trigger(LifeCycleEvent.willMount);
    }

    super.mount(parent, newSlot);

    if (_isRoot) {
      UseEvent.withInstance(_instance).trigger(LifeCycleEvent.didMount);
    }
  }

  void _updateAncestorScopeInheritedElement(Element? parent) {
    if (Id == Null) return;

    var inheritedElement = parent?.getElementForInheritedWidgetOfExactType<
            ReactterScopeInherited<T, Id>>()
        as ReactterScopeInheritedElement<T, Id>?;

    _continueUpdateAncestorScopeInheritedElement(inheritedElement);

    void callback() {
      _continueUpdateAncestorScopeInheritedElement(inheritedElement);

      inheritedElement?._subscribersManager
          .unsubscribe(InheritedElementStatus.mount, callback);
    }

    inheritedElement?._subscribersManager
        .subscribe(InheritedElementStatus.mount, callback);
  }

  void _continueUpdateAncestorScopeInheritedElement(
    ReactterScopeInheritedElement<T, Id>? parent,
  ) {
    if (parent != null && parent._ancestorScopeInheritedElement != null) {
      _ancestorScopeInheritedElement =
          HashMap<ReactterInstance, ReactterScopeInheritedElement<T, Id>>.of(
              parent._ancestorScopeInheritedElement!);
    } else {
      _ancestorScopeInheritedElement =
          HashMap<ReactterInstance, ReactterScopeInheritedElement<T, Id>>();
    }

    _ancestorScopeInheritedElement![ReactterInstance<T>(widget.owner._id)] =
        this;
  }

  ReactterScopeInheritedElement<T, Id>? getScopeInheritedElementOfExactId(
    String id,
  ) =>
      _ancestorScopeInheritedElement?[ReactterInstance<T>(id)];

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final dependencies = getDependencies(dependent);
    // once subscribed to everything once, it always stays subscribed to everything.
    if (dependencies != null && dependencies is! _Dependency<T>) {
      return;
    }

    if (aspect is SelectorAspect<T>) {
      final selectorDependency =
          (dependencies ?? _Dependency<T>()) as _Dependency<T>;

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
      if (dependencies is _Dependency<T>) {
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
  Widget build() {
    _removeDependencies();
    notifyClients(widget);

    return super.build();
  }

  @override
  void unmount() {
    if (_isRoot) {
      UseEvent.withInstance(_instance).trigger(LifeCycleEvent.willUnmount);
    }
    widget.owner._deleteInstance(this);

    _ancestorScopeInheritedElement = null;
    _instance = null;
    _removeDependencies();

    return super.unmount();
  }

  void dependOnHooks(List<ReactterHook> hooks) {
    for (int i = 0; i < hooks.length; i++) {
      final hook = hooks[i];
      final unsubscribe = hook.onDidUpdate((_, __) => markNeedsBuild());

      _unsubscribersDependencies.add(unsubscribe);
    }
  }

  void dependOnInstance(T instance) {
    if (instance == null) {
      return;
    }

    final unsubscribe = instance.onDidUpdate((_, __) => markNeedsBuild());

    _unsubscribersDependencies.add(unsubscribe);
  }

  /// Unsubscribes dependencies
  void _removeDependencies() {
    for (var i = 0; i < _unsubscribersDependencies.length; i++) {
      _unsubscribersDependencies[i].call();
    }

    _unsubscribersDependencies.clear();
  }

  void _createInstance() {
    _isRoot = !widget.owner._existsInstance();
    _instance = widget.owner._createInstance(this) as T;
  }
}

class _Dependency<T> {
  bool shouldClearSelectors = false;
  bool shouldClearMutationScheduled = false;
  final selectors = <SelectorAspect<T>>[];
}
