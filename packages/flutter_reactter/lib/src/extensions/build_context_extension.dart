part of '../extensions.dart';

/// Exposes methods to helps to get and listen the Object instance.
extension ReactterBuildContextExtension on BuildContext {
  /// Gets the instance of [T] type from the closest ancestor of [ReactterProvider]
  /// and listens changes to the instance or the states([ReactterState]) defined
  /// in first parameter([listenStates]) to trigger re-render of the Widget tree.
  ///
  /// ```dart
  /// final appController = context.watch<AppController>();
  /// final appControllerWatchStates = context.watch<AppController>(
  ///   (inst) => [inst.stateA],
  /// );
  /// final appControllerNullable = context.wath<AppController?>();
  /// ```
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [watch] will return `null`.
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, listenStates: listenStates);
  /// ```
  T watch<T extends Object?>([ListenStates<T>? listenStates]) {
    return ReactterProvider.contextOf<T>(this, listenStates: listenStates);
  }

  /// Gets the instance of [T] type by [id] from the closest ancestor
  /// of [ReactterProvider] and watchs changes to the instance or
  /// the states([ReactterState]) defined in first parameter([listenStates])
  /// to trigger re-render of the Widget tree.
  ///
  /// ```dart
  /// final appController = context.watchId<AppController>("UniqueId");
  /// final appControllerWatchHook = context.watchId<AppController>(
  ///   "UniqueId",
  ///   (inst) => [inst.stateA],
  /// );
  /// final appControllerNullable = context.wathId<AppController?>("UniqueId");
  /// ```
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [watchId] will return `null`.
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listenStates: listenStates);
  /// ```
  T watchId<T extends Object?>(
    String id, [
    ListenStates<T>? listenStates,
  ]) {
    return ReactterProvider.contextOf<T>(
      this,
      id: id,
      listenStates: listenStates,
    );
  }

  /// Gets the instance of [T] type with/without [id]
  /// from the closest ancestor of [ReactterProvider].
  ///
  /// ```dart
  /// final appController = context.use<AppController>();
  /// final appControllerId = context.use<AppController>('uniqueId');
  /// final appControllerNullable = context.use<AppController?>();
  /// ```
  ///
  /// If [T] is nullable and no matching instance is found,
  /// [use] will return `null`.
  ///
  /// If [T] is non-nullable and the instance obtained returned `null`,
  /// will throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listen: false);
  /// ```
  T use<T extends Object?>([String? id]) {
    return ReactterProvider.contextOf<T>(this, id: id, listen: false);
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
