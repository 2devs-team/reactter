library reactter;

import 'package:flutter/widgets.dart';
import '../core/reactter_types.dart';
import '../core/mixins/reactter_life_cycle.dart';
import '../core/reactter_context.dart';
import '../engine/reactter_inherit_provider.dart';
import '../engine/reactter_inherit_provider_scope.dart';
import '../engine/reactter_inherit_provider_scope_element.dart';
import '../hooks/reactter_use_context.dart';

/// Takes all the [UseContext] of [ReactterContext] defined on [contexts]
/// and it's provides to [builder] method through [BuildContext] as parameter.
/// For access to the instances of [ReactterContext]
/// is necessary use the methods of [ReactterBuildContextExtension].
///
/// It is also responsible for fires the lifecycle events of [ReactterContext],
///
/// This example produces one [ReactterProvider] with an [AppContext] inside:
///
/// ```dart
/// ReactterProvider(
///   contexts: [
///     UseContext(() => AppContext()),
///   ],
///   child: Icon(Icons.person),
///   builder: (context, child) {
///     final appContext = context.of<AppContext>();
///
///     return Row(
///       children: [
///         Text(appContext.name.value),
///         child,
///       ],
///     );
///   },
/// )
/// ```
class ReactterProvider extends ReactterInheritedProvider {
  /// Stores all [UseContext]
  @protected
  final List<UseContextAbstraction> contexts;

  ReactterProvider({
    Key? key,
    required this.contexts,
    Widget? child,
    TransitionBuilder? builder,
  }) : super(
          key: key,
          child: child,
          builder: builder,
        ) {
    // Necessary to keep data in hotreload.
    _initialize();
  }

  /// Initializes every instance of [contexts]
  _initialize() {
    for (var i = 0; i < contexts.length; i++) {
      contexts[i].initialize(true);
    }
  }

  /// Executes lifecycle [willMount] from every [ReactterContext]
  @override
  @protected
  willMount() => _triggerLifeCycleEvent(LifeCycleEvent.willMount);

  /// Executes lifecycle [didMount] from every [ReactterContext]
  @override
  @protected
  didMount() => _triggerLifeCycleEvent(LifeCycleEvent.didMount);

  /// Executes lifecycle [willUpdate] from every [ReactterContext]
  @override
  @protected
  willUpdate() => _triggerLifeCycleEvent(LifeCycleEvent.willUpdate);

  /// Executes lifecycle [didUpdate] from every [ReactterContext]
  @override
  @protected
  didUpdate() => _triggerLifeCycleEvent(LifeCycleEvent.didUpdate);

  /// Destroys every instance of [contexts]
  /// and executes it's lifecycle [willUnmount].
  @override
  @protected
  willUnmount() {
    _triggerLifeCycleEvent(LifeCycleEvent.willUnmount);

    for (var i = 0; i < contexts.length; i++) {
      contexts[i].destroy();
    }
  }

  void _triggerLifeCycleEvent(LifeCycleEvent event, [bool force = false]) {
    for (var i = 0; i < contexts.length; i++) {
      if (force || contexts[i].isRoot) {
        contexts[i].instance?.executeEvent(event);
      }
    }
  }

  /// Returns a [instance] of [T]
  /// and puts contexts listen to when it should be re-rendered
  static T contextOf<T extends ReactterContext?>(
    BuildContext context, {
    String? id,
    ListenHooks<T>? listenHooks,
    SelectorAspect? aspect,
    bool listen = true,
  }) {
    final _inheritedElement = _inheritedElementOf(context);
    final _instance = _getInstance<T>(context, id);

    if (!listen || _instance == null) {
      return _instance as T;
    }

    if (listenHooks != null) {
      final _hooks = listenHooks(_instance);

      for (var i = 0; i < _hooks.length; i++) {
        _inheritedElement?.dependOnInstance(_hooks[i]);
      }
    } else {
      _inheritedElement?.dependOnInstance(_instance);
    }

    if (aspect != null) {
      context.dependOnInheritedElement(_inheritedElement!, aspect: aspect);
    } else {
      context
          .dependOnInheritedWidgetOfExactType<ReactterInheritedProviderScope>();
    }

    return _instance;
  }

  /// Obtain the [instance] of [T] from nearest ancestor [ReactterProvider]
  static T? _getInstance<T>(BuildContext context, String? id) {
    T? instance;

    context.visitAncestorElements((parent) {
      final _inheritedElement = parent.getElementForInheritedWidgetOfExactType<
              ReactterInheritedProviderScope>()
          as ReactterInheritedProviderScopeElement?;

      if (_inheritedElement?.widget.owner is! ReactterProvider) return true;

      final _contexts =
          (_inheritedElement?.widget.owner as ReactterProvider?)?.contexts;

      if (_contexts == null) return true;

      for (var i = 0; i < _contexts.length; i++) {
        final _useContext = _contexts[i];

        if (_useContext.instance is T && _useContext.id == id) {
          instance = _useContext.instance as T?;
          break;
        }
      }

      return instance == null;
    });

    if (instance == null && null is! T) {
      throw ReactterContextNotFoundException(T, context.widget.runtimeType);
    }

    return instance;
  }

  /// An InheritedProvider<T>'s update tries to obtain a parent provider of
  /// the same type.
  static ReactterInheritedProviderScopeElement? _inheritedElementOf(
    BuildContext context,
  ) {
    ReactterInheritedProviderScopeElement? inheritedElement;

    if (context.widget is ReactterInheritedProviderScope) {
      context.visitAncestorElements((parent) {
        inheritedElement = parent.getElementForInheritedWidgetOfExactType<
                ReactterInheritedProviderScope>()
            as ReactterInheritedProviderScopeElement?;
        return false;
      });
    } else {
      inheritedElement = context.getElementForInheritedWidgetOfExactType<
              ReactterInheritedProviderScope>()
          as ReactterInheritedProviderScopeElement?;
    }

    return inheritedElement;
  }
}

/// Exposes methods to helps to get and listen the [instance] of [ReactterContext].
extension ReactterBuildContextExtension on BuildContext {
  /// Obtain a [instance] of [T] from the nearest ancestor [ReactterProvider],
  /// and subscribe to it or specific hooks put in [listenHooks] parameter.
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [of] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.of<AppContext?>();
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
  ///   final appContext = context.of<AppContext>(
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
  T of<T extends ReactterContext?>([ListenHooks<T>? listenHooks]) =>
      ReactterProvider.contextOf<T>(this, listenHooks: listenHooks);

  /// Obtain a [instance] of [T] with [id] from the nearest ancestor [ReactterProvider],
  /// and subscribe to it or specific hooks put in [listenHooks] parameter.
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [ofId] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.ofId<AppContext?>('uniqueId');
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
  ///   final appContext = context.of<AppContext>(
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
  T ofId<T extends ReactterContext?>(
    String id, [
    ListenHooks<T>? listenHooks,
  ]) =>
      ReactterProvider.contextOf<T>(this, id: id, listenHooks: listenHooks);

  /// Obtain a [instance] of [T] from the nearest ancestor [ReactterProvider].
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [ofStatic] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.ofStatic<AppContext?>();
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
  T ofStatic<T extends ReactterContext?>() =>
      ReactterProvider.contextOf<T>(this, listen: false);

  /// Obtain a [instance] of [T] with [id] from the nearest ancestor [ReactterProvider].
  ///
  /// If [T] is nullable and no matching [ReactterContext] are found, [ofIdStatic] will
  /// return `null`.
  ///
  /// If [T] is non-nullable and the [ReactterContext] obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// Builder(builder: (context) {
  ///   final appContext = context.ofStatic<AppContext?>('uniqueId');
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
  T ofIdStatic<T extends ReactterContext?>(String id) =>
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
Error: Could not find the correct `UseContext<$valueType>` above this `$widgetType` Widget

This happens because you used a `BuildContext` that does not include the `ReactterContext`
of your choice. There are a few common scenarios:

- You added a new `ReactterProvider` in your `main.dart` and performed a hot-reload.
  To fix, perform a hot-restart.

- The `ReactterContext` you are trying to read is in a different route.

  `UseContext are "scoped". So if you insert of `UseContext` inside a route, then
  other routes will not be able to access that `ReactterContext`.

- You used a `BuildContext` that is an ancestor of the provider you are trying to read.

  Make sure that `$widgetType` is under your `ReactterProvider` with `UseContext<$valueType>`.
  This usually happens when you are creating a `ReactterContext` and trying to read it immediately.

  For example, instead of:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => AppContext())
      ],
      // Will throw a `ReactterContextNotFoundException`, because `context` is associated
      // to the widget that is the parent of `ReactterProvider`.
      child: Text(context.of<AppContext>().state.value),
    ),
  }
  ```

  consider using `builder` like so:

  ```
  Widget build(BuildContext context) {
    return ReactterProvider(
      contexts: [
        UseContext(() => AppContext())
      ],
      // we use `builder` to obtain a new `BuildContext` that has access to the provider
      builder: (context) {
        // No longer throws
        return Text(context.of<AppContext>().state.value),
      }
    ),
  }
  ```

If none of these solutions work, consider asking for help on StackOverflow:
https://stackoverflow.com/questions/tagged/flutter
''';
  }
}
