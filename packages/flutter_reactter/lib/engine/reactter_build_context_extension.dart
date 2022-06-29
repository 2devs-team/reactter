part of '../widgets.dart';

/// Exposes methods to helps to get and listen the [instance] of [ReactterContext].
extension ReactterBuildContextExtension on BuildContext {
  /// Obtain a [instance] of [T] from the nearest ancestor [ReactterProvider],
  /// and subscribe to it or specific hooks put in [listenHooks] parameter.
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [watch] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.watch<AppContext?>();
  ///
  ///   if (appContext == null) Text('no found');
  ///
  ///   return Text(appContext.state.value);
  /// }),
  /// ```
  ///
  /// If only need to listen to one or some hooks,
  /// use [listenHooks] which is first parameter:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.watch<AppContext>(
  ///     (ctx) => [ctx.stateA, ctx.stateB],
  ///   );
  ///
  ///   return Text(appContext.stateA.value);
  /// }),
  /// ```
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, listenHooks: listenHooks);
  /// ```
  T watch<T extends ReactterContext?>([ListenHooks<T>? listenHooks]) =>
      ReactterProvider.contextOf<T>(this, listenHooks: listenHooks);

  /// Obtain a [instance] of [T] with [id] from the nearest ancestor [ReactterProvider],
  /// and subscribe to it or specific hooks put in [listenHooks] parameter.
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [watchId] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.watchId<AppContext?>('uniqueId');
  ///
  ///   if (appContext == null) Text('no found');
  ///
  ///   return Text(appContext.state.value);
  /// }),
  /// ```
  ///
  /// If only need to listen to one or some hooks,
  /// use [listenHooks] which is second parameter:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.watchId<AppContext>(
  ///     'uniqueId',
  ///     (ctx) => [ctx.stateA, ctx.stateB],
  ///   );
  ///
  ///   return Text(appContext.stateA.value);
  /// }),
  /// ```
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listenHooks: listenHooks);
  /// ```
  T watchId<T extends ReactterContext?>(
    String id, [
    ListenHooks<T>? listenHooks,
  ]) =>
      ReactterProvider.contextOf<T>(this, id: id, listenHooks: listenHooks);

  /// Obtain a [instance] of [T] from the nearest ancestor [ReactterProvider].
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [read] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.read<AppContext?>();
  ///
  ///   if (appContext == null) Text('no found');
  ///
  ///   return Text(appContext.state.value);
  /// }),
  /// ```
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, listen: false);
  /// ```
  T read<T extends ReactterContext?>() =>
      ReactterProvider.contextOf<T>(this, listen: false);

  /// Obtain a [instance] of [T] with [id] from the nearest ancestor [ReactterProvider].
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [readId] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.readId<AppContext?>('uniqueId');
  ///
  ///   if (appContext == null) Text('no found');
  ///
  ///   return Text(appContext.state.value);
  /// }),
  /// ```
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// ReactterProvider.contextOf<T>(context, id: id, listen: false);
  /// ```
  T readId<T extends ReactterContext?>(String id) =>
      ReactterProvider.contextOf<T>(this, id: id, listen: false);
}

/// The error that will be thrown if [ReactterProvider.contextOf] fails to find a [ReactterContext]
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

This happens because you used a `BuildContext` that does not include the `ReactterContext`
of your choice. There are a few common scenarios:

- You added a new `ReactterProvider` in your `main.dart` and performed a hot-reload.
  To fix, perform a hot-restart.

- The `ReactterContext` you are trying to read is in a different route.

  `ReactterProvider` are "scoped". So if you insert of `ReactterProvider` inside a route, then
  other routes will not be able to access that `ReactterContext`.

- You used a `BuildContext` that is an ancestor of the provider you are trying to read.

  Make sure that `$widgetType` is under your `ReactterProvider<$valueType>`.
  This usually happens when you are creating a `ReactterContext` and trying to read it immediately.

  For example, instead of:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => AppContext(),
      // Will throw a `ReactterContextNotFoundException`, because `context` is associated
      // to the widget that is the parent of `ReactterProvider`.
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
