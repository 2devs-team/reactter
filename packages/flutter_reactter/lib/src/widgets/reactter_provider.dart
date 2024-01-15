// ignore_for_file: prefer_void_to_null

part of '../widgets.dart';

/// {@template reactter_provider}
/// A Widget that provides an instance of [T] type to widget tree
/// that can be access through the methods [BuildContext] extension.
///
/// ```dart
/// ReactterProvider<AppController>(
///   () => AppController(),
///   builder: (context, appController, child) {
///     return Text("StateA: ${appController.stateA.value}");
///   },
/// )
/// ```
///
/// Use [id] property to identify the [T] instance.
///
/// Use [child] property to pass a [Widget] which to be built once only.
/// It will be sent through the [builder] callback, so you can incorporate it
/// into your build:
///
/// ```dart
/// ReactterProvider<AppController>(
///   () => AppController(),
///   child: Text("This widget build only once"),
///   builder: (context, _, __) {
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
/// ```
/// > **RECOMMENDED:**
/// > Dont's use Object with constructor parameters to prevent conflicts.
///
/// > **NOTE:**
/// > [ReactterProvider] is a "scoped". This mean that [ReactterProvider]
/// exposes the instance of [T] type defined on second parameter([InstanceChildBuilder])
/// through the [BuildContext] in the widget subtree:
/// >
/// > ```dart
/// > ReactterProvider<AppController>(
/// >   () => AppController(),
/// >   builder: (context, appController, child) {
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
/// > ```
/// >
/// > In the above example, stateA remains static while the [Builder] is rebuilt
/// > according to the changes in stateB. Because the [Builder]'s context kept in
/// > watch of stateB.
///
/// See also:
///
/// * [ReactterProviders], a widget that allows to use multiple [ReactterProvider].
/// {@endtemplate}
class ReactterProvider<T extends Object?> extends ProviderBase<T>
    implements ProviderWrapper, ProviderRef {
  /// {@macro reactter_provider}
  const ReactterProvider(
    InstanceBuilder<T> instanceBuilder, {
    Key? key,
    String? id,
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

  Widget buildWithChild(Widget? child) {
    if (id != null) {
      return ProvideImpl<T, WithId>(
        instanceBuilder,
        ref: this,
        key: key,
        id: id,
        mode: mode,
        init: init,
        builder: builder,
        child: child,
      );
    }
    return ProvideImpl<T, WithoutId>(
      instanceBuilder,
      ref: this,
      key: key,
      mode: mode,
      init: init,
      builder: builder,
      child: child,
    );
  }

  @override
  ReactterProviderElement<T> createElement() =>
      ReactterProviderElement<T>(this);

  /// Returns an instance of [T]
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
    return Reactter.getHashCodeRefAt<T>(0, widget.id) == _widget.hashCode;
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
