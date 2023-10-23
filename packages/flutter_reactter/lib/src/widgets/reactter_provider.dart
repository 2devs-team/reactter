// ignore_for_file: prefer_void_to_null, invalid_use_of_protected_member

part of '../widgets.dart';

/// An abstract class that extends [InheritedWidget] and implements
/// [ReactterWrapperWidget].
@internal
abstract class ReactterProviderAbstraction<T extends Object>
    extends InheritedWidget implements ReactterWrapperWidget {
  const ReactterProviderAbstraction({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  ReactterProviderElement createElement();
}

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
class ReactterProvider<T extends Object> extends ReactterProviderAbstraction {
  /// {@macro reactter_provider}
  const ReactterProvider(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.mode = InstanceManageMode.builder,
    this.init = false,
    Widget? child,
    this.builder,
  }) : super(
          key: key,
          // `child` is required because the super class is a InheritedWidget.
          child: child ?? const _UndefinedWidget(),
        );

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

  Widget build(BuildContext context) {
    return _buildWithChild(child is _UndefinedWidget ? null : child);
  }

  @override
  ReactterProviderElement createElement() {
    return ReactterProviderElement<T>(
      widget: this,
      id: id,
      mode: mode,
    );
  }

  /// This is a hack to save it and find it with the `id` distinction
  /// in `_inheritedWidgets` of `Element` using the helper functions
  /// of `BuildContext` like `getElementForInheritedWidgetOfExactType`.
  @override
  Type get runtimeType {
    Type getType<TT>() => TT;

    if (id != null) {
      return getType<_ReactterProviderKey<T, String>>();
    }

    return getType<_ReactterProviderKey<T, Null>>();
  }

  /// A [build] method that receives an extra `child` parameter.
  ///
  /// This method may be called with a `child` different from the parameter
  /// passed to the constructor of [SingleChildStatelessWidget].
  /// It may also be called again with a different `child`, without this widget
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
              _ReactterProviderKey<T, String>>() as ReactterProviderElement<T>?;

      return inheritedElementNotSure?.getInheritedElementOfExactId(id);
    }

    // To find it without id, is O(1) complexity
    return context.getElementForInheritedWidgetOfExactType<
        _ReactterProviderKey<T, Null>>() as ReactterProviderElement<T>?;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

/// `ReactterProviderElement` is a class that manages the lifecycle of the `ReactterInstance` and
/// provides the `ReactterInstance` to its descendants
@internal
class ReactterProviderElement<T extends Object?> extends InheritedElement
    with ReactterWrapperElementMixin, ReactterScopeElementMixin {
  final String? _id;
  final InstanceManageMode mode;
  Widget? _widget;
  bool _isRoot = false;
  Map<String, ReactterProviderElement<T>>? _inheritedElementsWithId;

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
      Reactter.emit(_instance, Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (_isRoot) {
      Reactter.emit(_instance, Lifecycle.didMount);
    }
  }

  @override
  Widget build() {
    if (instanceOrStatesDirty.isNotEmpty) {
      notifyClients(widget);

      return _widget!;
    }

    if (parent != null) {
      return _widget = widget._buildWithChild(parent?.injectedChild);
    }

    return _widget = widget.build(this);
  }

  @override
  void unmount() {
    if (_isRoot) {
      Reactter.emit(_instance, Lifecycle.willUnmount);
    }

    Reactter.delete<T>(_id, this);

    _inheritedElementsWithId = null;
    _widget = null;

    return super.unmount();
  }

  /// Gets [ReactterProviderElement] that it has the [ReactterInstance]'s id.
  ReactterProviderElement<T>? getInheritedElementOfExactId(
    String id,
  ) =>
      _inheritedElementsWithId?[ReactterInstance.generateKey<T?>(id)];

  /// updates [inheritedElementsWithId]
  /// with all ancestor [ReactterProviderElement] with id
  void _updateInheritedElementWithId(Element? parent) {
    if (_id == null) return;

    var ancestorInheritedElement =
        parent?.getElementForInheritedWidgetOfExactType<
            _ReactterProviderKey<T, String>>() as ReactterProviderElement<T>?;

    if (ancestorInheritedElement?._inheritedElementsWithId != null) {
      _inheritedElementsWithId = HashMap<String, ReactterProviderElement<T>>.of(
        ancestorInheritedElement!._inheritedElementsWithId!,
      );
    } else {
      _inheritedElementsWithId = HashMap<String, ReactterProviderElement<T>>();
    }

    final instanceKey = ReactterInstance.generateKey<T?>(widget.id);
    _inheritedElementsWithId![instanceKey] = this;
  }
}

abstract class _ReactterProviderKey<T extends Object?, Id extends String?>
    extends InheritedWidget {
  // coverage:ignore-start
  const _ReactterProviderKey({Key? key})
      : super(key: key, child: const _UndefinedWidget());
  // coverage:ignore-end
}

class _UndefinedWidget extends Widget {
  const _UndefinedWidget({Key? key}) : super(key: key);

  // coverage:ignore-start
  @override
  Element createElement() {
    throw UnimplementedError();
  }
  // coverage:ignore-end
}
