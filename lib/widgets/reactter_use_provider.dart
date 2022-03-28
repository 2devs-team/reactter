library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_types.dart';
import 'package:reactter/engine/mixins/reactter_life_cycle.dart';
import 'package:reactter/engine/widgets/reactter_inherit_provider.dart';
import 'package:reactter/engine/widgets/reactter_inherit_provider_scope.dart';
import 'package:reactter/engine/widgets/reactter_inherit_provider_scope_element.dart';
import 'package:reactter/widgets/reactter_use_context.dart';
import 'package:reactter/hooks/reactter_hook.dart';

class ReactterContext extends ReactterHook with ReactterLifeCycle {}

class UseProvider extends ReactterInheritedProvider {
  final List<UseContextAbstraction> contexts;
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
    initialize();
  }

  initialize() {
    for (var _context in contexts) {
      _context.initialize(true);

      if (_context.instance is ReactterContext) {
        (_context.instance as ReactterContext).willMount();
      }

      instanceMapper[_context.instance.runtimeType] = _context.instance;
    }
  }

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

  didMount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance
        ..didMount()
        ..subscribe(inheritedElement.markNeedsBuild);
    });
  }

  willUnmount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance
        ..willUnmount()
        ..unsubscribe(inheritedElement.markNeedsBuild);
    });
  }

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

  static ReactterInheritedProviderScopeElement? _inheritedElementOf(
    BuildContext context,
  ) {
    // ignore: unnecessary_null_comparison, can happen if the application depends on a non-migrated code
    assert(context != null, '''
Tried to call context.read/watch/select or similar on a `context` that is null.

This can happen if you used the context of a StatefulWidget and that
StatefulWidget was disposed.
''');
    ReactterInheritedProviderScopeElement? inheritedElement;

    if (context.widget is ReactterInheritedProviderScope) {
      // An InheritedProvider<T>'s update tries to obtain a parent provider of
      // the same type.
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

    // if (inheritedElement == null && null is! T) {
    //   // throw ProviderNotFoundException(T, context.widget.runtimeType);
    // }

    return inheritedElement;
  }

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
  Widget buildWithChild(BuildContext context, Widget? child) {
    final _inheritedElementParent = _inheritedElementOf(context);

    if (_inheritedElementParent != null) {
      final _useProviderParent =
          (_inheritedElementParent.widget.owner as UseProvider);
      instanceMapper.addAll(_useProviderParent.instanceMapper);

      // Execute after build.
      // Search child inheritedElement and add it to dependencies instance
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

    return super.buildWithChild(context, child);
  }
}
