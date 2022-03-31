library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_types.dart';
import '../engine/mixins/reactter_life_cycle.dart';
import '../engine/widgets/reactter_inherit_provider.dart';
import '../engine/widgets/reactter_inherit_provider_scope.dart';
import '../engine/widgets/reactter_inherit_provider_scope_element.dart';
import '../widgets/reactter_use_context.dart';
import '../hooks/reactter_hook.dart';

/// Provide the functionlatiy of [ReactterHook] and [ReactterLifeCycle] to any class.
///
/// We recommend to call you class with `Context` to improve readability.
///
///```dart
/// class AppContext extends ReactterContext {
///     late final name = UseState<String>('Leo León', context: this);
/// }
/// ```
/// To use it, you should provide it wih [UseProvider] and [UseContext],
/// you can access to the prop values with [ReactterBuildContextExtension].
///
/// This example produces on [UseProvider] with an [UseContext] of type [AppContext],
/// and read all the states in builder:
///
/// ```dart
/// UseProvider(
///  contexts: [
///    UseContext(
///      () => AppContext(),
///      init: true,
///    )
///  ],
///  builder: (context) {
///     appContext = context.of<AppContext>();
///
///     return Text(appContext.name.value);
///   }
/// )
/// ```
class ReactterContext extends ReactterHook with ReactterLifeCycle {}

/// Provide [contexts] to his builder.
///
/// This widget always must be called if you want to provide any state.
///
/// All the context in [contexts] going to be provided to this builder.
///
/// This example produces one [UseProvider] with an [AppContext] inside.
/// but you can use as many you need
///
/// ```dart
/// UseProvider(
///  contexts: [
///    UseContext(
///      () => AppContext(),
///      init: true,
///    )
///  ],
///  builder: () => Container();
/// )
/// ```
class UseProvider extends ReactterInheritedProvider {
  /// All the context that going to be provided to this builder.
  /// This example produces one [UseProvider].
  ///
  /// ```dart
  /// UseProvider(
  ///  contexts: [
  ///    UseContext(
  ///      () => AppContext(),
  ///      init: true,
  ///    )
  ///  ],
  ///  builder: () => Container();
  /// )
  /// ```
  final List<UseContextAbstraction> contexts;

  /// Save all the instances living inside this [UseProvider].
  ///
  /// This object is who controls the state in every [UseProvider].
  final Map<Type, Object?> instanceMapper = {};

  UseProvider({
    Key? key,
    required this.contexts,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          builder: builder,
          child: child,
        ) {
    // Necessary to keep data in hotreload.
    initialize();
  }

  /// Initialize every instance inside [instanceMapper]
  /// and executes his [awake()] method.
  initialize() {
    for (var _context in contexts) {
      _context.initialize(true);

      if (_context.instance is ReactterContext) {
        (_context.instance as ReactterContext).awake();
      }

      instanceMapper[_context.instance.runtimeType] = _context.instance;
    }
  }

  /// Iterates his children to set an action in every state.
  _iterateContextWithInherit(
      ReactterInheritedProviderScopeElement inheritedElement,
      Function(ReactterContext) action) {
    for (var _context in contexts) {
      if (_context.instance is ReactterContext) {
        final instance = _context.instance as ReactterContext;

        action(instance);
      }
    }
  }

  /// Executes all [willMount] from every [ReactterContext] in his children.
  willMount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance.willMount();
    });
  }

  /// Executes all [didMount] methods from every [ReactterContext] in his children and add
  /// the [markNeedsBuild] method to his listener for update when state change.
  didMount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance
        ..didMount()
        ..subscribe(inheritedElement.markNeedsBuild);
    });
  }

  /// Executes all [willUnmount] methods from every [ReactterContext] in his children and remove
  /// the [markNeedsBuild] method from his listener.
  willUnmount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance
        ..willUnmount()
        ..unsubscribe(inheritedElement.markNeedsBuild);
    });
  }

  /// Returns all the listeners of the given [ReactterContext]
  static T? of<T>(
    BuildContext context, {
    bool listen = false,
    SelectorAspect? aspect,
  }) {
    final _inheritedElement = _inheritedElementOf(context);
    final _instance = _inheritedElement?.getInstance<T>();

    if (listen) {
      if (aspect != null) {
        context.dependOnInheritedElement(_inheritedElement!, aspect: aspect);
      } else {
        context.dependOnInheritedWidgetOfExactType<
            ReactterInheritedProviderScope>();
      }
    }

    return _instance;
  }

  T? getInstance<T>() {
    return instanceMapper[T] as T?;
  }

  /// An InheritedProvider<T>'s update tries to obtain a parent provider of
  /// the same type.
  static ReactterInheritedProviderScopeElement? _inheritedElementOf(
    BuildContext context,
  ) {
    // ignore: unnecessary_null_comparison, can happen if the application depends on a non-migrated code.
    assert(context != null, '''
Tried to call context.read/watch/select or similar on a `context` that is null.

This can happen if you used the context of a StatefulWidget and that
StatefulWidget was disposed.
''');
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

  /// An InheritedProvider<T>'s tries to obtain children of the same type.
  static ReactterInheritedProviderScopeElement? _inheritedElementChildOf(
    BuildContext context,
  ) {
    ReactterInheritedProviderScopeElement? _inheritedElement;

    context.visitChildElements((element) {
      _inheritedElement = element.getElementForInheritedWidgetOfExactType<
              ReactterInheritedProviderScope>()!
          as ReactterInheritedProviderScopeElement?;
    });

    return _inheritedElement;
  }

  @override
  Widget build(BuildContext context) {
    final _inheritedElementParent = _inheritedElementOf(context);

    if (_inheritedElementParent != null) {
      final _useProviderParent =
          (_inheritedElementParent.widget.owner as UseProvider);
      instanceMapper.addAll(_useProviderParent.instanceMapper);

      /// Execute after build.
      /// Search child inheritedElement and add it to dependencies instance.
      Future.microtask(() {
        final _inheritedElement = _inheritedElementChildOf(context);

        if (_inheritedElement == null) {
          return;
        }

        for (var _instance in instanceMapper.values) {
          if (_instance is ReactterContext) {
            _instance.subscribe(_inheritedElement.markNeedsBuild);
          }
        }
      });
    }

    return super.build(context);
  }
}
