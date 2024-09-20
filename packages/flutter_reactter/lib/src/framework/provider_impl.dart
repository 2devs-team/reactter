// ignore_for_file: prefer_void_to_null

part of '../framework.dart';

@internal
abstract class ProviderRef {}

@internal
class ProvideImpl<T extends Object?, I extends String?> extends ProviderBase<T>
    implements InheritedWidget {
  final ProviderRef ref;

  const ProvideImpl(
    InstanceBuilder<T> instanceBuilder, {
    required this.ref,
    Key? key,
    I? id,
    DependencyMode mode = DependencyMode.builder,
    bool init = false,
    bool isLazy = false,
    Widget? child,
    InstanceChildBuilder<T>? builder,
    ChildBuilder? lazyBuilder,
  }) : super(
          instanceBuilder,
          key: key,
          id: id,
          mode: mode,
          init: init,
          isLazy: isLazy,
          child: child,
          builder: builder,
          lazyBuilder: lazyBuilder,
        );

  @override
  Widget get child {
    assert(
      super.child != null ||
          (!super.isLazy && super.builder != null ||
              super.isLazy && super.lazyBuilder != null),
    );

    if (super.isLazy && super.lazyBuilder != null) {
      return Builder(
        builder: (context) {
          return super.lazyBuilder!(context, super.child);
        },
      );
    }

    if (super.builder != null) {
      return Builder(
        builder: (context) {
          return super.builder!(context, context.use<T>(id), super.child);
        },
      );
    }

    return super.child!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  ProviderElement<T> createElement() => ProviderElement<T>(widget: this);

  /// Returns an instance of [T]
  /// and sets the [BuildContext] to listen for when it should be re-rendered.
  static T contextOf<T extends Object?>(
    BuildContext context, {
    String? id,
    ListenStates<T>? listenStates,
    bool listen = true,
  }) {
    if (T == getType<Object?>()) {
      RtScope.contextOf(
        context,
        listenStates: listenStates as ListenStates<Object?>?,
        listen: listen,
      );

      return null as T;
    }

    final providerInheritedElement =
        getProviderInheritedElement<T>(context, id);

    final instance = providerInheritedElement?.instance as T;

    if (!listen || instance == null) {
      return instance;
    }

    /// A way to tell the [BuildContext] that it should be re-rendered
    /// when the [ReactterInstance] or the [RtHook]s that are being listened
    /// change.
    context.dependOnInheritedElement(
      providerInheritedElement!,
      aspect: listenStates == null
          ? InstanceDependency(instance)
          : StatesDependency(listenStates(instance).toSet()),
    );

    return instance;
  }

  /// Returns the [ProviderElement] of the [RtProvider] that is
  /// closest to the [BuildContext] that was passed as arguments.
  static ProviderElement<T?>? getProviderInheritedElement<T extends Object?>(
    BuildContext context, [
    String? id,
  ]) {
    ProviderElement<T?>? providerInheritedElement;

    // To find it with id, is O(2) complexity(O(1)*2)
    if (id != null) {
      final inheritedElementNotSure =
          context.getElementForInheritedWidgetOfExactType<
              ProvideImpl<T?, WithId>>() as ProviderElement<T?>?;

      providerInheritedElement =
          inheritedElementNotSure?.getInheritedElementOfExactId(id);
    } else {
      // To find it without id, is O(1) complexity
      providerInheritedElement =
          context.getElementForInheritedWidgetOfExactType<
              ProvideImpl<T?, WithoutId>>() as ProviderElement<T?>?;
    }

    if (providerInheritedElement?.instance == null && null is! T) {
      throw RtDependencyNotFoundException(T, context.widget.runtimeType);
    }

    return providerInheritedElement;
  }
}

/// [ProviderElement] is a class that manages the lifecycle of the [RtDependency] and
/// provides the [RtDependency] to its descendants
@internal
class ProviderElement<T extends Object?> extends InheritedElement
    with ScopeElementMixin {
  static final Map<RtDependency, int> _instanceMountCount = {};

  Widget? _prevChild;
  HashMap<RtDependency, ProviderElement<T>>? _inheritedElementsWithId;
  bool _isLazyInstanceObtained = false;

  bool get isRoot {
    return Rt.getRefAt<T>(0, widget.id) == widget;
  }

  @override
  ProvideImpl<T, String?> get widget {
    return super.widget as ProvideImpl<T, String?>;
  }

  T? get instance {
    if (!_isLazyInstanceObtained && widget.isLazy) {
      final instance = Rt.get<T>(widget.id, widget);

      _isLazyInstanceObtained = instance != null;

      return instance;
    }

    return Rt.find<T>(widget.id);
  }

  /// Creates an element that uses the given widget as its configuration.
  ProviderElement({
    required ProvideImpl<T, String?> widget,
    String? id,
  }) : super(widget) {
    if (widget.init && !widget.isLazy) {
      // TODO: Remove this when the `init` property is removed
      Rt.create<T>(
        widget.instanceBuilder,
        id: widget.id,
        mode: widget.mode,
        ref: widget,
      );

      return;
    }

    Rt.register<T>(
      widget.instanceBuilder,
      id: widget.id,
      mode: widget.mode,
    );
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    final dependency = RtDependency<T?>(widget.id);
    var count = _instanceMountCount.putIfAbsent(dependency, () => 0);
    _instanceMountCount[dependency] = ++count;
    final shouldNotifyMount = count == 1;

    if (!widget.init && !widget.isLazy) {
      Rt.get<T>(widget.id, widget);
    }

    _updateInheritedElementWithId(parent);

    if (shouldNotifyMount) {
      Rt.emit(dependency, Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (shouldNotifyMount) {
      Rt.emit(dependency, Lifecycle.didMount);
    }
  }

  @override
  Widget build() {
    if (hasDependenciesDirty) {
      notifyClients(widget);

      if (_prevChild != null) return _prevChild!;
    }

    return _prevChild = super.build();
  }

  @override
  void unmount() {
    final id = widget.id;
    final ref = widget;
    final dependency = RtDependency<T?>(widget.id);
    final count = (_instanceMountCount[dependency] ?? 0) - 1;
    final shouldNotifyUnmount = count < 1;

    if (shouldNotifyUnmount) {
      _instanceMountCount.remove(dependency);
    } else {
      _instanceMountCount[dependency] = count;
    }

    try {
      if (shouldNotifyUnmount) {
        Rt.emit(dependency, Lifecycle.willUnmount);
      }

      return super.unmount();
    } finally {
      if (shouldNotifyUnmount) {
        Rt.emit(dependency, Lifecycle.didUnmount);
      }

      Rt.delete<T>(id, ref);
      _inheritedElementsWithId = null;
      _prevChild = null;
    }
  }

  /// Gets [ProviderElement] that it has the [RtDependency]'s id.
  ProviderElement<T>? getInheritedElementOfExactId(
    String id,
  ) =>
      _inheritedElementsWithId?[RtDependency<T?>(id)];

  /// updates [inheritedElementsWithId]
  /// with all ancestor [ProviderElement] with id
  void _updateInheritedElementWithId(Element? parent) {
    if (widget.id == null) return;

    var ancestorInheritedElement = parent
            ?.getElementForInheritedWidgetOfExactType<ProvideImpl<T, WithId>>()
        as ProviderElement<T>?;

    if (ancestorInheritedElement?._inheritedElementsWithId != null) {
      _inheritedElementsWithId = HashMap<RtDependency, ProviderElement<T>>.of(
        ancestorInheritedElement!._inheritedElementsWithId!,
      );
    } else {
      _inheritedElementsWithId = HashMap<RtDependency, ProviderElement<T>>();
    }

    _inheritedElementsWithId![RtDependency<T?>(widget.id)] = this;
  }
}

/// {@template flutter_reactter.rt_dependency_not_found_exception}
/// The error that will be thrown if [RtProvider.contextOf] fails
/// to find the dependency from ancestor of the [BuildContext] used.
/// {@endtemplate}
class RtDependencyNotFoundException implements Exception {
  const RtDependencyNotFoundException(
    this.valueType,
    this.widgetType,
  );

  /// The type of the value being retrieved
  final Type valueType;

  /// The type of the Widget requesting the value
  final Type widgetType;

  @override
  String toString() {
    return '''
Error: Could not find the correct `RtProvider<$valueType>` above this `$widgetType` Widget

This happens because you used a `BuildContext` that does not include the dependency of your choice.
There are a few common scenarios:

- You added a new `RtProvider` in your `main.dart` and perform a hot-restart.

- The dependency you are trying to read is in a different route.

  `RtProvider` is a "scoped". So if you insert of `RtProvider` inside a route, then
  other routes will not be able to access that dependency.

- You used a `BuildContext` that is an ancestor of the `RtProvider` you are trying to read.

  Make sure that `$widgetType` is under your `RtProvider<$valueType>`.
  This usually happens when you are creating an instance of the dependency and trying to read it immediately.

  For example, instead of:

  ```
  Widget build(BuildContext context) {
    return RtProvider(
      () => AppController(),
      // Will throw a `RtDependencyNotFoundException`,
      // because `context` is out of `RtProvider`'s scope.
      child: Text(context.watch<AppController>().state.value),
    ),
  }
  ```

  Try to use `builder` propery of `RtProvider` to access the dependency inmedately as it created, like so:

  ```
  Widget build(BuildContext context) {
    return RtProvider(
      () => AppController(),
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (context, appController, child) {
        // No longer throws
        context.watch<AppController>();
        return Text(appController.state.value),
      }
    ),
  }
  ```

If none of these solutions work, consider asking for help on StackOverflow:
https://stackoverflow.com/questions/tagged/flutter
''';
  }
}

/// {@macro flutter_reactter.provider_not_found_exception}
@Deprecated(
  'Use `RtDependencyNotFoundException` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterDependencyNotFoundException = RtDependencyNotFoundException;
