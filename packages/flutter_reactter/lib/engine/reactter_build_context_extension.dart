part of '../widgets.dart';

/// Exposes methods to helps to get and listen [ReactterContext]'s instance.
extension ReactterBuildContextExtension on BuildContext {
  /// Gets the [ReactterContext]'s instance of [T]
  /// from the closest ancestor of [ReactterProvider] and watch all [ReactterHook]
  /// or [ReactterHook] defined in first paramater([listenHooks])
  /// to re-render the widget tree.
  ///
  /// ```dart
  /// final appContext = context.watch<AppContext>();
  /// final appContextWatchHook = context.watch<AppContext>((ctx) => [ctx.stateHook]);
  /// final appContextNullable = context.wath<AppContext?>();
  /// ```
  ///
  /// If [T] is nullable and no matching [ReactterContext] is found, [watch] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, listenHooks: listenHooks);
  /// ```
  T watch<T extends ReactterContext?>([ListenHooks<T>? listenHooks]) =>
      ReactterProvider.contextOf<T>(this, listenHooks: listenHooks);

  /// Gets the [ReactterContext]'s instance of [T]
  /// from the closest ancestor of [ReactterProvider] and watch all [ReactterHook]
  /// or [ReactterHook] defined in second paramater([listenHooks])
  /// to re-render the widget tree.
  ///
  /// ```dart
  /// final appContext = context.watch<AppContext>();
  /// final appContextWatchHook = context.watch<AppContext>((ctx) => [ctx.stateHook]);
  /// final appContextNullable = context.wath<AppContext?>();
  /// ```
  ///
  /// If [T] is nullable and no matching [ReactterContext] is found, [watch] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, listenHooks: listenHooks);
  /// ```
  T watchId<T extends ReactterContext?>(String id,
          [ListenHooks<T>? listenHooks]) =>
      ReactterProvider.contextOf<T>(this, id: id, listenHooks: listenHooks);

  /// Gets the [ReactterContext]'s instance of [T] with/without [id]
  /// from the closest ancestor of [ReactterProvider].
  ///
  /// ```dart
  /// final appContext = context.use<AppContext>();
  /// final appContextId = context.use<AppContext>('uniqueId');
  /// final appContextNullable = context.use<AppContext?>();
  /// ```
  ///
  /// If [T] is nullable and no matching [ReactterContext] is found, [watch] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listen: false);
  /// ```
  T use<T extends ReactterContext?>([String? id]) =>
      ReactterProvider.contextOf<T>(this, id: id, listen: false);
}

/// The error that will be thrown
/// if [ReactterProvider.contextOf] fails to find a [ReactterContext]
/// as an ancestor of the [BuildContext] used.
class ReactterContextNotFoundException implements Exception {
  /// Create a ProviderNotFound error with the type represented as a String.
  ReactterContextNotFoundException(
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

This happens because you used a `BuildContext` that does not include the `ReactterContext` of your choice.
There are a few common scenarios:

- You added a new `ReactterProvider` in your `main.dart` and perform a hot-restart.

- The `ReactterContext` you are trying to read is in a different route.

  `ReactterProvider` is a "scoped". So if you insert of `ReactterProvider` inside a route, then
  other routes will not be able to access that `ReactterContext`.

- You used a `BuildContext` that is an ancestor of the `ReactterProvider` you are trying to read.

  Make sure that `$widgetType` is under your `ReactterProvider<$valueType>`.
  This usually happens when you are creating a `ReactterContext` and trying to read it immediately.

  For example, instead of:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => AppContext(),
      // Will throw a `ReactterContextNotFoundException`,
      // because `context` is out of `ReactterProvider`'s scope.
      child: Text(context.watch<AppContext>().state.value),
    ),
  }
  ```

  consider using `builder` like so:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => AppContext(),
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (context) {
        // No longer throws
        return Text(context.watch<AppContext>().state.value),
      }
    ),
  }
  ```

If none of these solutions work, consider asking for help on StackOverflow:
https://stackoverflow.com/questions/tagged/flutter
''';
  }
}
