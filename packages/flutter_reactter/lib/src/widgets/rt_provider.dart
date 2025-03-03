// ignore_for_file: prefer_void_to_null

part of '../widgets.dart';

/// {@template flutter_reactter.rt_provider}
/// A Widget that serves as a conduit for injecting a dependency of [T] type
/// into the widget tree. e.g.:
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   ...
///   @override
///   Widget build(context) {
///     return RtProvider<MyController>(
///       () => MyController(),
///       builder: (context, myController, child) {
///         return OtherWidget();
///       },
///     );
///   }
/// }
///
/// class OtherWidget extends StatelessWidget {
///   ...
///   @override
///   Widget build(context) {
///     // Get the dependency of `MyController` using the context.
///     final myController = context.use<MyController>();
///
///     return Column(
///       children: [
///         Text("StateA: ${myController.stateA.value}"),
///         Builder(
///           builder: (context){
///             // Watch the `stateB` of `MyController` dependency.
///             context.watch<MyController>((inst) => [inst.stateB]);
///
///             return Text("StateB: ${myController.stateB.value}");
///           },
///         ),
///       ],
///     );
///   }
/// }
/// ```
///
/// > **NOTE:**
/// > [RtProvider] is a "scoped". This mean that [RtProvider]
/// exposes the instance of [T] dependency to second parameter([InstanceChildBuilder])
/// through the [BuildContext] in the widget subtree:
/// >
/// > In the above example, stateA remains static while the [Builder] is rebuilt
/// > according to the changes in `stateB`. Because the [Builder]'s context kept in
/// > watch of `stateB`.
///
/// > **RECOMMENDED:**
/// > Dont's use Object with constructor parameters to prevent conflicts.
///
/// Use [id] property to identify the [T] dependency. e.g.:
///
/// ```dart
/// ...
/// RtProvider<MyController>(
///   () => MyController(),
///   id: 'uniqueId,
///   builder: (context, myController, child) {
///     return OtherWidget();
///   },
/// );
/// ...
/// final myController = context.use<MyController>(id: 'uniqueId');
/// ...
/// ```
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
/// ```dart
/// RtProvider<MyController>(
///   () => MyController(),
///   child: Text("This widget build only once"),
///   builder: (context, _, __) {
///     final myController = context.watch<MyController>();
///
///     return Column(
///       children: [
///         Text("state: ${myController.stateA.value}"),
///         child,
///       ],
///     );
///   },
/// )
/// ```
///
/// Use [init] property as `true` to create the instance of [T] dependency after mounting.
///
/// > **NOTE:**
/// > The [init] property is `false` by default. This means that the instance
/// will be created in the mounting.
///
/// Use [RtProvider.lazy] contructor for creating a lazy instance of [T] dependency.
/// This is particularly useful for optimizing performance
/// by lazy-loading instance only when it is needed. e.g.:
///
/// ```dart
/// RtProvider.lazy(
///   () => MyController(),
///   child: Text('Do Something'),
///   builder: (context, child) {
///     return ElevatedButton(
///       onPressed: () {
///         // The `MyController` instance is created here.
///         context.use<MyController>.doSomething();
///       },
///       child: child,
///     );
///   },
/// ),
/// ```
///
/// See also:
///
/// * [RtMultiProvider], a widget that allows to use multiple [RtProvider].
/// {@endtemplate}
class RtProvider<T extends Object?> extends ProviderBase<T>
    implements ProviderWrapper, ProviderRef<T> {
  /// Creates an instance of [T] dependency and provides it to tree widget.
  const RtProvider(
    InstanceBuilder<T> instanceBuilder, {
    Key? key,
    String? id,
    DependencyMode mode = DependencyMode.builder,
    Widget? child,
    InstanceChildBuilder<T>? builder,
  }) : super(
          instanceBuilder,
          key: key,
          id: id,
          mode: mode,
          child: child,
          builder: builder,
        );

  RtProvider.init(
    InstanceBuilder<T> instanceBuilder, {
    Key? key,
    String? id,
    DependencyMode mode = DependencyMode.builder,
    Widget? child,
    InstanceChildBuilder<T>? builder,
  }) : super(
          instanceBuilder,
          key: key,
          id: id,
          mode: mode,
          init: true,
          child: child,
          builder: builder,
        ) {
    createInstance();
  }

  /// Creates a lazy instance of [T] dependency and provides it to tree widget.
  const RtProvider.lazy(
    InstanceBuilder<T> instanceBuilder, {
    Key? key,
    String? id,
    DependencyMode mode = DependencyMode.builder,
    Widget? child,
    ChildBuilder? builder,
  }) : super(
          instanceBuilder,
          key: key,
          id: id,
          mode: mode,
          isLazy: true,
          child: child,
          lazyBuilder: builder,
        );

  @protected
  Widget buildWithChild(Widget? child) {
    if (id != null) {
      return ProvideImpl<T?, WithId>(
        instanceBuilder,
        ref: this,
        key: key,
        id: id,
        mode: mode,
        init: init,
        isLazy: isLazy,
        builder: builder == null
            ? null
            : (context, inst, child) => builder!(context, inst as T, child),
        lazyBuilder: lazyBuilder,
        child: child,
      );
    }
    return ProvideImpl<T?, WithoutId>(
      instanceBuilder,
      ref: this,
      key: key,
      mode: mode,
      init: init,
      isLazy: isLazy,
      builder: builder == null
          ? null
          : (context, inst, child) => builder!(context, inst as T, child),
      lazyBuilder: lazyBuilder,
      child: child,
    );
  }

  @protected
  @override
  void registerInstance() {
    Rt.register<T>(instanceBuilder, id: id, mode: mode);
  }

  @override
  T? findInstance() {
    return Rt.find<T>(id);
  }

  @protected
  @override
  T? getInstance() {
    return Rt.get<T>(id, this);
  }

  @protected
  @override
  T? createInstance() {
    return Rt.create<T>(instanceBuilder, id: id, mode: mode, ref: this);
  }

  @protected
  @override
  void disposeInstance() {
    Rt.delete<T>(id, this);
  }

  @protected
  @override
  void dispose() {
    disposeInstance();
  }

  @override
  RtProviderElement<T> createElement() => RtProviderElement<T>(this);

  /// Returns an instance of [T] dependency
  /// and sets the [BuildContext] to listen for when it should be re-rendered.
  static T contextOf<T extends Object?>(
    BuildContext context, {
    String? id,
    ListenStates<T>? listenStates,
    bool listen = true,
  }) =>
      ProvideImpl.contextOf<T>(
        context,
        id: id,
        listenStates: listenStates,
        listen: listen,
      );
}

class RtProviderElement<T extends Object?> extends ComponentElement
    with WrapperElementMixin<RtProvider<T>> {
  bool get isRoot {
    return Rt.getRefAt<T>(0, widget.id) == widget;
  }

  RtProviderElement(Widget widget) : super(widget);

  @override
  Widget build() {
    return widget.buildWithChild(parent?.injectedChild ?? widget.child);
  }

  @override
  void debugFillProperties(properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty(
        'id',
        widget.id,
        showName: true,
      ),
    );
    properties.add(
      FlagProperty(
        'isRoot',
        value: isRoot,
        ifTrue: 'true',
        ifFalse: 'false',
        showName: true,
      ),
    );
  }
}
