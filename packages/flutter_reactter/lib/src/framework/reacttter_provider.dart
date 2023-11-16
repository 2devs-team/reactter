part of '../framework.dart';

/// Abstract class to implementing a wrapper widget for [ReactterProvider]
@internal
abstract class ReactterProviderWrapper implements ReactterWrapperWidget {}

/// {@template reactter_provider}
/// A Widget that provides an instance of [T] type to widget tree
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
/// * [ReactterProviders], a widget that allows to use multiple [ReactterProvider].
/// {@endtemplate}
@internal
class ReactterProviderI<T extends Object?, I extends String?> extends Widget
    implements ReactterProvider<T> {
  /// {@template reactter_provider.id}
  /// It's used to identify the instance of [T] type
  /// that is provided by the provider.
  ///
  /// It allows you to have multiple instances of the same [T] type in
  /// your widget tree and differentiate between them.
  ///
  /// This can be useful when you want to provide
  /// different instances of a class to different parts of your application.
  /// {@endtemplate}
  final I? id;

  /// {@template reactter_provider.mode}
  /// It's used to specify the type of instance creation for the provided object.
  ///
  /// It is of mode [InstanceManageMode], which is an enum with three possible values:
  /// [InstanceManageMode.builder], [InstanceManageMode.factory] and [InstanceManageMode.singleton].
  /// {@endtemplate}
  final InstanceManageMode mode;

  /// {@template reactter_provider.instanceBuilder}
  /// Create a [T] instance.
  /// {@endtemplate}
  @protected
  final InstanceBuilder<T> instanceBuilder;

  /// {@template reactter_provider.init}
  /// Immediately create the instance defined
  /// on firts parameter([instanceBuilder]).
  /// {@endtemplate}
  @protected
  final bool init;

  /// {@template reactter_provider.builder}
  /// Method which has the render logic
  ///
  /// Exposes [BuilderContext] and [child] widget as arguments.
  /// and returns a widget.
  /// {@endtemplate}
  @protected
  final InstanceContextBuilder<T>? builder;

  final Widget? _child;

  const ReactterProviderI(
    this.instanceBuilder, {
    Key? key,
    this.id,
    this.mode = InstanceManageMode.builder,
    this.init = false,
    Widget? child,
    this.builder,
  })  : _child = child,
        super(key: key);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  ReactterProviderElement<T> createElement() {
    return ReactterProviderElement<T>(
      widget: this,
      id: id,
      mode: mode,
    );
  }

  @override
  Widget get child => buildWithChild(_child);

  Widget buildWithChild(Widget? child) {
    return Builder(
      builder: (context) {
        assert(child != null || builder != null);

        final instance = context.use<T>(id);

        return builder?.call(instance, context, child) ?? child!;
      },
    );
  }
}

/// [ReactterProviderElement] is a class that manages the lifecycle of the [ReactterInstance] and
/// provides the [ReactterInstance] to its descendants
@internal
class ReactterProviderElement<T extends Object?> extends InheritedElement
    with ReactterWrapperElementMixin, ReactterScopeElementMixin<T> {
  final String? _id;
  final InstanceManageMode mode;
  Widget? prevChild;
  bool _isRoot = false;
  HashMap<ReactterInstance, ReactterProviderElement<T>>?
      _inheritedElementsWithId;

  @override
  ReactterProviderI get widget => super.widget as ReactterProviderI;

  T? get instance => Reactter.find<T>(_id);

  /// Creates an element that uses the given widget as its configuration.
  ReactterProviderElement({
    required ReactterProviderI widget,
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
      Reactter.emit(instance!, Lifecycle.willMount);
    }

    super.mount(parent, newSlot);

    if (_isRoot) {
      Reactter.emit(instance!, Lifecycle.didMount);
    }
  }

  @override
  Widget build() {
    if (hasDependenciesDirty) {
      notifyClients(widget);

      if (prevChild != null) return prevChild!;
    }

    if (parent != null) {
      return prevChild = widget.buildWithChild(parent?.injectedChild);
    }

    return prevChild = super.build();
  }

  @override
  void unmount() {
    if (_isRoot) {
      Reactter.emit(instance!, Lifecycle.willUnmount);
    }

    Reactter.delete<T>(_id, this);

    _inheritedElementsWithId = null;
    prevChild = null;

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
            ReactterProviderI<T, WithId>>() as ReactterProviderElement<T>?;

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
