// ignore_for_file: prefer_void_to_null

part of '../widgets.dart';

/// {@macro reactter_provider}
abstract class ReactterProvider<T extends Object?>
    implements Widget, InheritedWidget, ReactterProviderWrapper {
  /// {@macro reactter_provider}
  factory ReactterProvider(
    InstanceBuilder<T> instanceBuilder, {
    Key? key,
    String? id,
    InstanceManageMode mode = InstanceManageMode.builder,
    bool init = false,
    Widget? child,
    InstanceContextBuilder<T>? builder,
  }) {
    if (id != null) {
      return ReactterProviderI<T, WithId>(
        instanceBuilder,
        key: key,
        id: id,
        mode: mode,
        init: init,
        builder: builder,
        child: child,
      );
    }

    return ReactterProviderI<T, WithoutId>(
      instanceBuilder,
      key: key,
      mode: mode,
      init: init,
      builder: builder,
      child: child,
    );
  }

  @override
  ReactterProviderElement<T> createElement();

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
        _getProviderInheritedElement<T>(context, id);

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
          ? ReactterInstanceDependency(instance)
          : ReactterStatesDependency(listenStates(instance).toSet()),
    );

    return instance;
  }

  /// Returns the [ReactterProviderElement] of the [ReactterProvider] that is
  /// closest to the [BuildContext] that was passed as arguments.
  static ReactterProviderElement<T>?
      _getProviderInheritedElement<T extends Object?>(
    BuildContext context, [
    String? id,
  ]) {
    ReactterProviderElement<T>? providerInheritedElement;

    // To find it with id, is O(2) complexity(O(1)*2)
    if (id != null) {
      final inheritedElementNotSure =
          context.getElementForInheritedWidgetOfExactType<
              ReactterProviderI<T, WithId>>() as ReactterProviderElement<T>?;

      providerInheritedElement =
          inheritedElementNotSure?.getInheritedElementOfExactId(id);
    } else {
      // To find it without id, is O(1) complexity
      providerInheritedElement =
          context.getElementForInheritedWidgetOfExactType<
              ReactterProviderI<T, WithoutId>>() as ReactterProviderElement<T>?;
    }

    if (providerInheritedElement?.instance == null && null is! T) {
      throw ReactterInstanceNotFoundException(T, context.widget.runtimeType);
    }

    return providerInheritedElement;
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
