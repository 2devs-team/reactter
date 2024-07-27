// ignore_for_file: prefer_void_to_null

part of '../widgets.dart';

/// {@template reactter_provider}
/// A Widget that serves as a conduit for injecting a dependency of [T] type
/// into the widget tree. e.g.:
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   ...
///   @override
///   Widget build(context) {
///     return ReactterProvider<MyController>(
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
/// > [ReactterProvider] is a "scoped". This mean that [ReactterProvider]
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
/// ReactterProvider<MyController>(
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
/// ReactterProvider<MyController>(
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
/// Use [ReactterProvider.lazy] contructor for creating a lazy instance of [T] dependency.
/// This is particularly useful for optimizing performance
/// by lazy-loading instance only when it is needed. e.g.:
///
/// ```dart
/// ReactterProvider.lazy(
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
/// * [ReactterProviders], a widget that allows to use multiple [ReactterProvider].
/// {@endtemplate}
class ReactterProvider<T extends Object?> extends ProviderBase<T>
    implements ProviderWrapper, ProviderRef {
  /// Creates an instance of [T] dependency and provides it to tree widget.
  const ReactterProvider(
    InstanceBuilder<T> instanceBuilder, {
    Key? key,
    String? id,
    DependencyMode mode = DependencyMode.builder,
    @Deprecated(
      'This feature not working anymore. It was deprecated after v7.2.0. '
      'Use `ReactterProvider.init` instead.',
    )
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

  ReactterProvider.init(
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
    Rt.create(
      instanceBuilder,
      id: id,
      mode: mode,
      ref: this,
    );
  }

  /// Creates a lazy instance of [T] dependency and provides it to tree widget.
  const ReactterProvider.lazy(
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

  @override
  ReactterProviderElement<T> createElement() =>
      ReactterProviderElement<T>(this);

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

class ReactterProviderElement<T extends Object?> extends ComponentElement
    with WrapperElementMixin<ReactterProvider<T>> {
  bool get isRoot {
    return Rt.getHashCodeRefAt<T>(0, widget.id) == _widget.hashCode;
  }

  final ReactterProvider<T> _widget;

  ReactterProviderElement(ReactterProvider<T> widget)
      : _widget = widget,
        super(widget);

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
