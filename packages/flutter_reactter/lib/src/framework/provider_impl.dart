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
    InstanceManageMode mode = InstanceManageMode.builder,
    bool init = false,
    Widget? child,
    InstanceChildBuilder<T>? builder,
  }) : super(
          instanceBuilder,
          key: key,
          id: id,
          mode: mode,
          init: init,
          child: child,
          builder: builder,
        );

  @override
  Widget get child {
    return Builder(
      builder: (context) {
        assert(super.child != null || builder != null);

        return builder?.call(context, context.use<T>(id), super.child) ??
            super.child!;
      },
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  ProviderElement<T> createElement() => ProviderElement<T>(
        widget: this,
      );

  /// Returns an instance of [T]
  /// and sets the [BuildContext] to listen for when it should be re-rendered.
  static T contextOf<T extends Object?>(
    BuildContext context, {
    String? id,
    ListenStates<T>? listenStates,
    bool listen = true,
  }) {
    if (T == getType<Object?>()) {
      ReactterScope.contextOf(
        context,
        id: id,
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
    /// when the [ReactterInstance] or the [ReactterHook]s that are being listened
    /// change.
    context.dependOnInheritedElement(
      providerInheritedElement!,
      aspect: listenStates == null
          ? InstanceDependency(instance)
          : StatesDependency(listenStates(instance).toSet()),
    );

    return instance;
  }

  /// Returns the [ProviderElement] of the [ReactterProvider] that is
  /// closest to the [BuildContext] that was passed as arguments.
  static ProviderElement<T>? getProviderInheritedElement<T extends Object?>(
    BuildContext context, [
    String? id,
  ]) {
    ProviderElement<T>? providerInheritedElement;

    // To find it with id, is O(2) complexity(O(1)*2)
    if (id != null) {
      final inheritedElementNotSure = context
              .getElementForInheritedWidgetOfExactType<ProvideImpl<T, WithId>>()
          as ProviderElement<T>?;

      providerInheritedElement =
          inheritedElementNotSure?.getInheritedElementOfExactId(id);
    } else {
      // To find it without id, is O(1) complexity
      providerInheritedElement =
          context.getElementForInheritedWidgetOfExactType<
              ProvideImpl<T, WithoutId>>() as ProviderElement<T>?;
    }

    if (providerInheritedElement?.instance == null && null is! T) {
      throw ReactterInstanceNotFoundException(T, context.widget.runtimeType);
    }

    return providerInheritedElement;
  }
}

/// [ProviderElement] is a class that manages the lifecycle of the [ReactterInstance] and
/// provides the [ReactterInstance] to its descendants
@internal
class ProviderElement<T extends Object?> extends InheritedElement
    with ScopeElementMixin {
  Widget? prevChild;
  HashMap<ReactterInstance, ProviderElement<T>>? _inheritedElementsWithId;

  bool get isRoot {
    return Reactter.getHashCodeRefAt<T>(0, widget.id) == widget.ref.hashCode;
  }

  @override
  ProvideImpl<T, String?> get widget {
    return super.widget as ProvideImpl<T, String?>;
  }

  T? get instance => Reactter.find<T>(widget.id);

  /// Creates an element that uses the given widget as its configuration.
  ProviderElement({
    required ProvideImpl<T, String?> widget,
    String? id,
  }) : super(widget) {
    if (widget.init) {
      Reactter.create<T>(
        widget.instanceBuilder,
        id: widget.id,
        mode: widget.mode,
        ref: widget.ref,
      );

      return;
    }

    Reactter.register<T>(
      widget.instanceBuilder,
      id: widget.id,
      mode: widget.mode,
    );
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    if (!widget.init) {
      Reactter.get<T>(widget.id, widget.ref);
    }

    _updateInheritedElementWithId(parent);

    if (isRoot) {
      Reactter.emit(instance!, Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (isRoot) {
      Reactter.emit(instance!, Lifecycle.didMount);
    }
  }

  @override
  Widget build() {
    if (hasDependenciesDirty) {
      notifyClients(widget);

      if (prevChild != null) return prevChild!;
    }

    return prevChild = super.build();
  }

  @override
  void unmount() {
    if (isRoot) {
      Reactter.emit(instance!, Lifecycle.willUnmount);
    }

    Reactter.delete<T>(widget.id, widget.ref);

    _inheritedElementsWithId = null;
    prevChild = null;

    return super.unmount();
  }

  /// Gets [ProviderElement] that it has the [ReactterInstance]'s id.
  ProviderElement<T>? getInheritedElementOfExactId(
    String id,
  ) =>
      _inheritedElementsWithId?[ReactterInstance<T?>(id)];

  /// updates [inheritedElementsWithId]
  /// with all ancestor [ProviderElement] with id
  void _updateInheritedElementWithId(Element? parent) {
    if (widget.id == null) return;

    var ancestorInheritedElement = parent
            ?.getElementForInheritedWidgetOfExactType<ProvideImpl<T, WithId>>()
        as ProviderElement<T>?;

    if (ancestorInheritedElement?._inheritedElementsWithId != null) {
      _inheritedElementsWithId =
          HashMap<ReactterInstance, ProviderElement<T>>.of(
        ancestorInheritedElement!._inheritedElementsWithId!,
      );
    } else {
      _inheritedElementsWithId =
          HashMap<ReactterInstance, ProviderElement<T>>();
    }

    _inheritedElementsWithId![ReactterInstance<T?>(widget.id)] = this;
  }
}

/// The error that will be thrown if [ReactterProvider.contextOf] fails
/// to find the instance from ancestor of the [BuildContext] used.
class ReactterInstanceNotFoundException implements Exception {
  const ReactterInstanceNotFoundException(
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
Error: Could not find the correct `ReactterProvider<$valueType>` above this `$widgetType` Widget

This happens because you used a `BuildContext` that does not include the instance of your choice.
There are a few common scenarios:

- You added a new `ReactterProvider` in your `main.dart` and perform a hot-restart.

- The instance you are trying to read is in a different route.

  `ReactterProvider` is a "scoped". So if you insert of `ReactterProvider` inside a route, then
  other routes will not be able to access that instance.

- You used a `BuildContext` that is an ancestor of the `ReactterProvider` you are trying to read.

  Make sure that `$widgetType` is under your `ReactterProvider<$valueType>`.
  This usually happens when you are creating a instance and trying to read it immediately.

  For example, instead of:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => AppController(),
      // Will throw a `ReactterInstanceNotFoundException`,
      // because `context` is out of `ReactterProvider`'s scope.
      child: Text(context.watch<AppController>().state.value),
    ),
  }
  ```

  Try to use `builder` propery of `ReactterProvider` to access the instance inmedately as it created, like so:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
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
