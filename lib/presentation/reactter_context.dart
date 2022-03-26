import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reactter/reactter.dart';

typedef Create<T> = T Function();

class ReactterContext {
  final Set<UseHook> _hooks = {}; //_contextHooks
  final Set<void Function()> _removeListeners = {};
  final Set<InheritedElement> _dependencies = {};

  void addDependency(InheritedElement dependency) {
    _dependencies.add(dependency);
  }

  void removeDependency(InheritedElement dependency) {
    _dependencies.remove(dependency);
  }

  void listenHooks(List<UseHook> hooks) {
    for (final _hook in hooks) {
      if (_hooks.contains(_hook)) {
        return;
      }
      _hooks.add(_hook);

      if (_hook is UseState) {
        final _removeListener = _hook.didUpdate((_, __) {
          for (final _dependency in _dependencies) {
            _dependency.markNeedsBuild();
          }
        });

        _removeListeners.add(_removeListener);
      }
    }
  }

  void removeHookListener() {
    for (final _removeListener in _removeListeners) {
      _removeListener();
    }
  }
}

abstract class _ReactterContext<T extends Object> {
  T? get instance;

  void initialize([bool init = false]);
  void destroy();
}

class UseContext<T extends Object> extends _ReactterContext {
  final String id;
  final bool init;
  final bool isCreated;

  T? _instance;

  UseContext(
    Create<T> create, {
    this.init = false,
    this.isCreated = false,
    this.id = "",
  }) {
    Reactter.factory.register<T>(create);

    initialize(init);
  }

  @override
  T? get instance => _instance;
  set instance(T? value) => _instance = value;

  @override
  initialize([bool init = false]) {
    if (!init) return;

    if (instance != null) return;

    instance = Reactter.factory.getInstance<T>(isCreated, 'ContextProvider');
  }

  @override
  destroy() {
    if (instance == null) return;

    Reactter.factory.deleted(instance!);
  }
}

extension BuildContextExtension on BuildContext {
  T $<T>([List<UseState> Function(T instance)? selector]) {
    T? _instance;

    if (selector == null) {
      _instance = UseProvider.of<T>(this, listen: true);
    } else {
      Iterable<dynamic>? _valueStates;

      _instance = UseProvider.of<T>(this, listen: true, aspect: (_) {
        final _valueStatesToCompared = selector(_instance!);

        for (var index = 0; index <= _valueStatesToCompared.length; index++) {
          if (_valueStatesToCompared[index].value != _valueStates) {
            return true;
          }
        }

        return false;
      });

      _valueStates = selector(_instance!).map((state) => state.value);
    }

    assert(_instance != null, 'Instance "$T" does not exist');

    return _instance!;
  }

  T static<T>() => UseProvider.of<T>(this)!;
}

class UseProvider extends ReactterInheritedProvider {
  final List<_ReactterContext> contexts;
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

      instanceMapper[_context.instance.runtimeType] = _context.instance;
    }
  }

  addDependencyToContexts(
      _ReactterInheritedProviderScopeElement inheritedElement) {
    final _useProvider = (inheritedElement.widget.owner as UseProvider);

    for (var _context in _useProvider.contexts) {
      if (_context.instance is ReactterContext) {
        final instance = _context.instance as ReactterContext;
        instance.addDependency(inheritedElement);
      }
    }
  }

  removeDependencyFromContexts(
      _ReactterInheritedProviderScopeElement inheritedElement) {
    final _useProvider = (inheritedElement.widget.owner as UseProvider);

    for (var _context in _useProvider.contexts) {
      if (_context.instance is ReactterContext) {
        final instance = _context.instance as ReactterContext;
        instance.removeDependency(inheritedElement);
      }
    }
  }

  static T? of<T>(
    BuildContext context, {
    bool listen = false,
    _SelectorAspect? aspect,
  }) {
    final _inheritedElement = _inheritedElementOf(context);
    final _instance = _inheritedElement?.getInstance<T>();

    if (listen) {
      if (aspect != null) {
        context.dependOnInheritedElement(_inheritedElement!, aspect: aspect);
      } else {
        context.dependOnInheritedWidgetOfExactType<
            _ReactterInheritedProviderScope>();
      }
    }

    return _instance;
  }

  T? getInstance<T>() {
    return instanceMapper[T] as T?;
  }

  static _ReactterInheritedProviderScopeElement? _inheritedElementOf(
    BuildContext context,
  ) {
    // ignore: unnecessary_null_comparison, can happen if the application depends on a non-migrated code
    assert(context != null, '''
Tried to call context.read/watch/select or similar on a `context` that is null.

This can happen if you used the context of a StatefulWidget and that
StatefulWidget was disposed.
''');
    _ReactterInheritedProviderScopeElement? inheritedElement;

    if (context.widget is _ReactterInheritedProviderScope) {
      // An InheritedProvider<T>'s update tries to obtain a parent provider of
      // the same type.
      context.visitAncestorElements((parent) {
        inheritedElement = parent.getElementForInheritedWidgetOfExactType<
                _ReactterInheritedProviderScope>()
            as _ReactterInheritedProviderScopeElement?;
        return false;
      });
    } else {
      inheritedElement = context.getElementForInheritedWidgetOfExactType<
              _ReactterInheritedProviderScope>()
          as _ReactterInheritedProviderScopeElement?;
    }

    // if (inheritedElement == null && null is! T) {
    //   // throw ProviderNotFoundException(T, context.widget.runtimeType);
    // }

    return inheritedElement;
  }

  static _ReactterInheritedProviderScopeElement? _inheritedElementChildOf(
    BuildContext context,
  ) {
    _ReactterInheritedProviderScopeElement? _inheritedElement;

    context.visitChildElements((element) {
      _inheritedElement = element.getElementForInheritedWidgetOfExactType<
              _ReactterInheritedProviderScope>()!
          as _ReactterInheritedProviderScopeElement?;
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

        for (var _instance in instanceMapper.values) {
          if (_instance is ReactterContext) {
            _instance.addDependency(_inheritedElement!);
          }
        }
      });
    }

    return super.buildWithChild(context, child);
  }
}

class UseBuilder<T> extends SingleChildStatelessWidget {
  /// {@template provider.consumer.constructor}
  /// Consumes a [Provider<T>]
  /// {@endtemplate}
  UseBuilder({
    Key? key,
    required this.builder,
    Widget? child,
  }) : super(key: key, child: child);

  /// {@template provider.consumer.builder}
  /// Build a widget tree based on the value from a [Provider<T>].
  ///
  /// Must not be `null`.
  /// {@endtemplate}
  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
  ) builder;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return builder(
      context,
      UseProvider.of<T>(context) as T,
      child,
    );
  }
}

typedef BuildWithChild = Widget Function(BuildContext context, Widget? child);

class ReactterInheritedProvider extends SingleChildStatelessWidget {
  const ReactterInheritedProvider({
    Key? key,
    this.builder,
    Widget? child,
  }) : super(key: key);

  final BuildWithChild? builder;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      builder != null || child != null,
      '$runtimeType must used builder and/or child',
    );

    return _ReactterInheritedProviderScope(
      owner: this,
      child: builder != null
          ? Builder(
              builder: (context) => builder!(context, child),
            )
          : child!,
    );
  }
}

class _ReactterInheritedProviderScope extends InheritedWidget {
  const _ReactterInheritedProviderScope({
    required this.owner,
    required Widget child,
  }) : super(child: child);

  final ReactterInheritedProvider owner;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  @override
  _ReactterInheritedProviderScopeElement createElement() {
    return _ReactterInheritedProviderScopeElement(this);
  }
}

class _ReactterInheritedProviderScopeElement extends InheritedElement {
  _ReactterInheritedProviderScopeElement(_ReactterInheritedProviderScope widget)
      : super(widget);

  // static int _nextProviderId = 0;

  bool _shouldNotifyDependents = false;
  // bool _debugInheritLocked = false;
  // bool _isNotifyDependentsEnabled = true;
  // bool _firstBuild = true;
  bool _updatedShouldNotify = false;
  // bool _isBuildFromExternalSources = false;
  // late String _debugId;

  @override
  _ReactterInheritedProviderScope get widget =>
      super.widget as _ReactterInheritedProviderScope;

  T? getInstance<T>() {
    return (widget.owner as UseProvider).getInstance<T>();
  }

  // @override
  // void reassemble() {
  //   super.reassemble();

  //   final value = _delegateState.hasValue ? _delegateState.value : null;
  //   if (value is ReassembleHandler) {
  //     value.reassemble();
  //   }
  // }

  @override
  void mount(Element? parent, dynamic newSlot) {
    (widget.owner as UseProvider).addDependencyToContexts(this);

    super.mount(parent, newSlot);
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final dependencies = getDependencies(dependent);
    // once subscribed to everything once, it always stays subscribed to everything

    final testObject = dependent;
    if (dependencies != null && dependencies is! _Dependency) {
      return;
    }

    if (aspect is _SelectorAspect) {
      final selectorDependency = (dependencies ?? _Dependency()) as _Dependency;

      if (selectorDependency.shouldClearSelectors) {
        selectorDependency.shouldClearSelectors = false;
        selectorDependency.selectors.clear();
      }
      if (selectorDependency.shouldClearMutationScheduled == false) {
        selectorDependency.shouldClearMutationScheduled = true;
        Future.microtask(() {
          selectorDependency
            ..shouldClearMutationScheduled = false
            ..shouldClearSelectors = true;
        });
      }
      selectorDependency.selectors.add(aspect);
      setDependencies(dependent, selectorDependency);
    } else {
      // subscribes to everything
      setDependencies(dependent, const Object());
    }
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    final dependencies = getDependencies(dependent);

    // if (kDebugMode) {
    //   ProviderBinding.debugInstance.providerDidChange(_debugId);
    // }

    var shouldNotify = false;
    if (dependencies != null) {
      if (dependencies is _Dependency) {
        // select can never be used inside `didChangeDependencies`, so if the
        // dependent is already marked as needed build, there is no point
        // in executing the selectors.
        if (dependent.dirty) {
          return;
        }

        for (final updateShouldNotify in dependencies.selectors) {
          try {
            // assert(() {
            //   _debugIsSelecting = true;
            //   return true;
            // }());
            shouldNotify = updateShouldNotify(this);
            // shouldNotify = updateShouldNotify(value);
          } finally {
            // assert(() {
            //   _debugIsSelecting = false;
            //   return true;
            // }());
          }
          if (shouldNotify) {
            break;
          }
        }
      } else {
        shouldNotify = true;
      }
    }

    if (shouldNotify) {
      dependent.didChangeDependencies();
    }
  }

  // @override
  // void performRebuild() {
  //   if (_firstBuild) {
  //     _firstBuild = false;
  //     _delegateState = widget.owner._delegate.createState()..element = this;
  //   }
  //   super.performRebuild();
  // }

  @override
  void update(_ReactterInheritedProviderScope newWidget) {
//     assert(() {
//       if (widget.owner._delegate.runtimeType !=
//           newWidget.owner._delegate.runtimeType) {
//         throw StateError('''
// Rebuilt $widget using a different constructor.

// This is likely a mistake and is unsupported.
// If you're in this situation, consider passing a `key` unique to each individual constructor.
// ''');
//       }
//       return true;
//     }());

    // _isBuildFromExternalSources = true;
    // _updatedShouldNotify =
    //     _delegateState.willUpdateDelegate(newWidget.owner._delegate);
    _updatedShouldNotify = true;
    super.update(newWidget);
    _updatedShouldNotify = false;
  }

  @override
  void updated(InheritedWidget oldWidget) {
    super.updated(oldWidget);
    if (_updatedShouldNotify) {
      notifyClients(oldWidget);
    }
  }

  // @override
  // void didChangeDependencies() {
  //   // _isBuildFromExternalSources = true;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build() {
    // if (widget.owner._lazy == false) {
    // value; // this will force the value to be computed.
    // }
    // _delegateState.build(
    //   isBuildFromExternalSources: _isBuildFromExternalSources,
    // );
    // _isBuildFromExternalSources = false;
    // if (_shouldNotifyDependents) {
    // _shouldNotifyDependents = false;
    notifyClients(widget);
    // }
    return super.build();
  }

  @override
  void unmount() {
    // _delegateState.dispose();
    // if (kDebugMode) {
    //   ProviderBinding.debugInstance.providerDetails = {
    //     ...ProviderBinding.debugInstance.providerDetails,
    //   }..remove(_debugId);
    // }
    (widget.owner as UseProvider).removeDependencyFromContexts(this);
    super.unmount();
  }

  // @override
  // bool get hasValue => _delegateState.hasValue;

  // // @override
  // void markNeedsNotifyDependents() {
  //   // if (!_isNotifyDependentsEnabled) {
  //   //   return;
  //   // }

  //   markNeedsBuild();
  //   _shouldNotifyDependents = true;
  // }

  // bool _debugSetInheritedLock(bool value) {
  //   assert(() {
  //     _debugInheritLocked = value;
  //     return true;
  //   }());
  //   return true;
  // }

  // @override
  // T get value => _delegateState.value;

//   @override
//   InheritedWidget dependOnInheritedElement(
//     InheritedElement ancestor, {
//     Object? aspect,
//   }) {
//     assert(() {
//       if (_debugInheritLocked) {
//         throw FlutterError.fromParts(
//           <DiagnosticsNode>[
//             ErrorSummary(
//               'Tried to listen to an InheritedWidget '
//               'in a life-cycle that will never be called again.',
//             ),
//             ErrorDescription('''
// This error typically happens when calling Provider.of with `listen` to `true`,
// in a situation where listening to the provider doesn't make sense, such as:
// - initState of a StatefulWidget
// - the "create" callback of a provider

// This is undesired because these life-cycles are called only once in the
// lifetime of a widget. As such, while `listen` is `true`, the widget has
// no mean to handle the update scenario.

// To fix, consider:
// - passing `listen: false` to `Provider.of`
// - use a life-cycle that handles updates (like didChangeDependencies)
// - use a provider that handles updates (like ProxyProvider).
// '''),
//           ],
//         );
//       }
//       return true;
//     }());
//     return super.dependOnInheritedElement(ancestor, aspect: aspect);
//   }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   _delegateState.debugFillProperties(properties);
  // }
}

typedef _SelectorAspect<T> = bool Function(InheritedElement inheritedElement);

class _Dependency<T> {
  bool shouldClearSelectors = false;
  bool shouldClearMutationScheduled = false;
  final selectors = <_SelectorAspect<T>>[];
}

// @immutable
// abstract class _Delegate<T> {
//   _DelegateState<T, _Delegate<T>> createState();

//   // void debugFillProperties(DiagnosticPropertiesBuilder properties) {}
// }

// abstract class _DelegateState<T, D extends _Delegate<T>> {
//   _ReactterInheritedProviderScopeElement<T?>? element;

//   T get value;

//   D get delegate => element!.widget.owner._delegate as D;

//   bool get hasValue;

//   // bool debugSetInheritedLock(bool value) {
//   //   return element!._debugSetInheritedLock(value);
//   // }

//   bool willUpdateDelegate(D newDelegate) => false;

//   void dispose() {}

//   // void debugFillProperties(DiagnosticPropertiesBuilder properties) {}

//   void build({required bool isBuildFromExternalSources}) {}
// }
