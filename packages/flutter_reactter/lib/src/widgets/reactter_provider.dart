// ignore_for_file: prefer_void_to_null, invalid_use_of_protected_member

part of '../widgets.dart';

@internal
abstract class ReactterProviderWrapper implements ReactterWrapperWidget {}

abstract class _ReactterProvider<T extends Object?>
    implements InheritedWidget {}

abstract class _ReactterProviderWithId<T extends Object?>
    implements InheritedWidget {}

/// {@template reactter_provider}
/// A [StatelessWidget] that provides an instance of [T] type to widget tree
/// that can be access through the methods [BuildContext] extension.
///
///```dart
/// ReactterProvider<AppController>(
///   () => AppController(),
///   builder: (appController, context, child) {
///     return Text("StateA: ${appController.stateA.value}");
///   },
/// )
///```
///
/// Use [id] property to identify the [T] instance.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
///```dart
/// ReactterProvider<AppController>(
///   () => AppController(),
///   child: Text("This widget build only once"),
///   builder: (context, child) {
///     final appController = context.watch<AppController>();
///
///     return Column(
///       children: [
///         Text("state: ${appController.stateA.value}"),
///         child,
///       ],
///     );
///   },
/// )
///```
/// > **RECOMMENDED:**
/// > Dont's use Object with constructor parameters to prevent conflicts.
///
/// > **NOTE:**
/// > [ReactterProvider] is a "scoped". This mean that [ReactterProvider]
/// exposes the instance of [T] type defined on first parameter([InstanceContextBuilder])
/// through the [BuildContext] in the widget subtree:
/// >
/// >```dart
/// > ReactterProvider<AppController>(
/// >   () => AppController(),
/// >   builder: (appController, context, child) {
/// >     return OtherWidget();
/// >   }
/// > );
/// >
/// > class OtherWidget extends StatelessWidget {
/// >   ...
/// >   Widget build(context) {
/// >      final appController = context.use<AppController>();
/// >
/// >      return Column(
/// >       children: [
/// >         Text("StateA: ${appController.stateA.value}"),
/// >         Builder(
/// >           builder: (context){
/// >             context.watch<AppController>((inst) => [inst.stateB]);
/// >
/// >             return Text("StateB: ${appController.stateB.value}");
/// >           },
/// >         ),
/// >       ],
/// >     );
/// >   }
/// > }
/// >```
/// >
/// > In the above example, stateA remains static while the [Builder] is rebuilt
/// > according to the changes in stateB. Because the [Builder]'s context kept in
/// > watch of stateB.
///
/// See also:
///
/// * [ReactterProvider], a widget that allows to use multiple [ReactterProvider].
/// > {@endtemplate}
class ReactterProvider<T extends Object> extends Widget
    implements ReactterProviderWrapper, _ReactterProvider<T> {
  /// It's used to identify the instance of [T] type
  /// that is provided by the provider.
  ///
  /// It allows you to have multiple instances of the same [T] type in
  /// your widget tree and differentiate between them.
  ///
  /// This can be useful when you want to provide
  /// different instances of a class to different parts of your application.
  final String? id;

  /// It's used to specify the type of instance creation for the provided object.
  ///
  /// It is of mode [InstanceManageMode], which is an enum with three possible values:
  /// [InstanceManageMode.builder], [InstanceManageMode.factory] and [InstanceManageMode.singleton].
  final InstanceManageMode mode;

  /// Create a [T] instance.
  @protected
  final InstanceBuilder<T> instanceBuilder;

  /// Immediately create the instance defined
  /// on firts parameter([instanceBuilder]).
  @protected
  final bool init;

  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as parameters.
  /// and returns a widget.
  @protected
  final InstanceContextBuilder<T>? builder;

  final Widget? _child;

  final Type _type;

  /// {@macro reactter_provider}
  ReactterProvider(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.mode = InstanceManageMode.builder,
    this.init = false,
    Widget? child,
    this.builder,
  })  : _child = child,
        _type = (id == null
            ? getType<_ReactterProvider<T>>()
            : getType<_ReactterProviderWithId<T>>()),
        super(key: key);

  @override
  ReactterProviderElement<T> createElement() {
    return ReactterProviderElement<T>(
      widget: this,
      id: id,
      mode: mode,
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  Type get runtimeType => _type;

  /// A [build] method that receives an extra [child] parameter.
  ///
  /// This method may be called with a [child] different from the parameter
  /// passed to the constructor of [SingleChildStatelessWidget].
  /// It may also be called again with a different [child], without this widget
  /// being recreated.
  Widget _buildWithChild(Widget? child) {
    return Builder(
      builder: (context) {
        assert(child != null || builder != null);

        final instance = context.use<T>(id);

        return builder?.call(instance, context, child) ?? child!;
      },
    );
  }

  @override
  Widget get child => _buildWithChild(_child);

  /// Returns an instance of [T]
  /// and sets the `BuildContext` to listen for when it should be re-rendered.
  static T contextOf<T extends Object?>(
    BuildContext context, {
    String? id,
    ListenStates<T>? listenStates,
    bool listen = true,
  }) {
    final providerInheritedElement =
        _getProviderInheritedElement<T>(context, id);

    if (providerInheritedElement?._instance == null && null is! T) {
      throw ReactterInstanceNotFoundException(T, context.widget.runtimeType);
    }

    final instance = providerInheritedElement?._instance as T;

    if (!listen || instance == null) {
      return instance;
    }

    /// A way to tell the `BuildContext` that it should be re-rendered
    /// when the `ReactterInstance` or the `ReactterHook`s that are being listened
    /// change.
    context.dependOnInheritedElement(
      providerInheritedElement!,
      aspect: ReactterDependency<T?>(
        id: id,
        instance: listenStates != null ? null : instance,
        states: listenStates?.call(instance).toSet(),
      ),
    );

    return instance;
  }

  /// Returns the `ReactterProviderElement` of the `ReactterProvider` that is
  /// closest to the `BuildContext` that was passed as arguments.
  static ReactterProviderElement?
      _getProviderInheritedElement<T extends Object?>(
    BuildContext context, [
    String? id,
  ]) {
    // To find it with id, is O(2) complexity(O(1)*2)
    if (id != null) {
      final inheritedElementNotSure =
          context.getElementForInheritedWidgetOfExactType<
              _ReactterProviderWithId<T>>() as ReactterProviderElement<T>?;

      return inheritedElementNotSure?.getInheritedElementOfExactId(id);
    }

    // To find it without id, is O(1) complexity
    return context
            .getElementForInheritedWidgetOfExactType<_ReactterProvider<T>>()
        as ReactterProviderElement<T>?;
  }
}

/// [ReactterProviderElement] is a class that manages the lifecycle of the [ReactterInstance] and
/// provides the [ReactterInstance] to its descendants
@internal
class ReactterProviderElement<T extends Object?> extends InheritedElement
    with ReactterWrapperElementMixin, ReactterScopeElementMixin {
  final String? _id;
  final InstanceManageMode mode;
  Widget? child;
  bool _isRoot = false;
  HashMap<ReactterInstance, ReactterProviderElement<T>>?
      _inheritedElementsWithId;

  @override
  ReactterProvider get widget => super.widget as ReactterProvider;

  T? get _instance => Reactter.find<T>(_id);

  /// Creates an element that uses the given widget as its configuration.
  ReactterProviderElement({
    required ReactterProvider widget,
    this.mode = InstanceManageMode.builder,
    String? id,
  })  : _id = id,
        super(widget) {
    if (widget.init) {
      _isRoot = !Reactter.exists<T>(_id);
      Reactter.create<T>(
        widget.instanceBuilder as InstanceBuilder<T>,
        id: _id,
        mode: mode,
        ref: this,
      );

      return;
    }

    Reactter.register<T>(
      widget.instanceBuilder as InstanceBuilder<T>,
      id: _id,
      mode: mode,
    );
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty('id', widget.id, showName: true),
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
    if (!widget.init) {
      _isRoot = !Reactter.exists<T>(_id);
      Reactter.get<T>(_id, this);
    }

    _updateInheritedElementWithId(parent);

    if (_isRoot) {
      Reactter.emit(_instance!, Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (_isRoot) {
      Reactter.emit(_instance!, Lifecycle.didMount);
    }
  }

  @override
  Widget build() {
    if (hasDependenciesDirty) {
      notifyClients(widget);

      if (child != null) return child!;
    }

    if (parent != null) {
      return child = widget._buildWithChild(parent?.injectedChild);
    }

    return child = super.build();
  }

  @override
  void unmount() {
    if (_isRoot) {
      Reactter.emit(_instance!, Lifecycle.willUnmount);
    }

    Reactter.delete<T>(_id, this);

    _inheritedElementsWithId = null;
    child = null;

    return super.unmount();
  }

  /// Gets [ReactterProviderElement] that it has the [ReactterInstance]'s id.
  ReactterProviderElement<T>? getInheritedElementOfExactId(
    String id,
  ) =>
      _inheritedElementsWithId?[ReactterInstance<T?>(id)];

  /// updates [inheritedElementsWithId]
  /// with all ancestor [ReactterProviderElement] with id
  void _updateInheritedElementWithId(Element? parent) {
    if (_id == null) return;

    var ancestorInheritedElement =
        parent?.getElementForInheritedWidgetOfExactType<
            _ReactterProviderWithId<T>>() as ReactterProviderElement<T>?;

    if (ancestorInheritedElement?._inheritedElementsWithId != null) {
      _inheritedElementsWithId =
          HashMap<ReactterInstance, ReactterProviderElement<T>>.of(
        ancestorInheritedElement!._inheritedElementsWithId!,
      );
    } else {
      _inheritedElementsWithId =
          HashMap<ReactterInstance, ReactterProviderElement<T>>();
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
      builder: (appController, context, child) {
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
