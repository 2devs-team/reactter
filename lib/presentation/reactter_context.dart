import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';
import 'package:reactter/reactter.dart';

class ReactterContext {
  ReactterContext();

  List<UseState>? _states;
  void Function()? _whenChanged;

  set whenChanged(void Function() fn) {
    _whenChanged = fn;

    for (final state in _states ?? []) {
      state.didUpdate((_, newValue) {
        _whenChanged?.call();
      });
    }
  }

  void renderWhenStateChanged(List<UseState> states) {
    _states = states;
  }
}

typedef Create<T> = T Function();

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

extension ReactterBuildContext on BuildContext {
  T $<T>([
    List<UseState> Function(T instance)? selector,
  ]) {
    Iterable<dynamic>? _valueStates;
    T? _instance;

    _instance = UseProvider.of<T>(this, listen: selector != null, aspect: (_) {
      final _valueStatesToCompared = selector?.call(_instance!) ?? [];

      for (var index = 0; index <= _valueStatesToCompared.length; index++) {
        if (_valueStatesToCompared[index].value != _valueStates) {
          return true;
        }
      }

      return false;
    });

    _valueStates = selector?.call(_instance!).map((state) => state.value);

    assert(_instance != null, 'Instance "$T" does not exist');

    // final _instance = ReactterProvider.of(this)?.getInstance<T>();

    // ReactterProvider.of(this, listen: true, aspect: (_) {
    //   final _valueStatesToCompared = selector?.call(_instance!) ?? [];

    //   for (var index = 0; index <= _valueStatesToCompared.length; index++) {
    //     if (_valueStatesToCompared[index].value != _valueStates) {
    //       return true;
    //     }
    //   }

    //   return false;
    // });

    return _instance!;
  }
}

class Test {}

class UseProvider extends ReactterInheritedProvider {
  final List<_ReactterContext> contexts;
  final Map<Type, Object?> _instanceMapper = {};

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

      _instanceMapper[_context.instance.runtimeType] = _context.instance;
    }
  }

  setRebuilds(InheritedElement inheritedElement) {
    for (var _context in contexts) {
      if (_context.instance is ReactterContext) {
        final instance = _context.instance as ReactterContext;
        instance.whenChanged = () => inheritedElement.markNeedsBuild();
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

    // return listen
    //     ? context
    //         .dependOnInheritedWidgetOfExactType<
    //             ReactterInheritedWidget<ReactterProviderState>>(aspect: aspect)
    //         ?.data
    //     : context.findAncestorStateOfType<ReactterProviderState>();
  }

  T? getInstance<T>() {
    return _instanceMapper[T] as T?;
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
    // assert(
    //   _debugIsSelecting == false,
    //   'Cannot call context.read/watch/select inside the callback of a context.select',
    // );
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
}

// class ReactterProvider extends StatefulWidget {
//   const ReactterProvider(
//       {Key? key, required this.contexts, required this.builder})
//       : super(key: key);

//   final List<_ReactterContext> contexts;
//   final Widget Function(BuildContext context) builder;

//   static T? getContext<T extends Object>(BuildContext context) {
//     final ReactterProviderState? mainState =
//         context.findAncestorStateOfType<ReactterProviderState>();

//     if (mainState == null) {
//       return null;
//     }

//     for (var controller in mainState.contexts!) {
//       if (controller is T) {
//         return ReactterFactory().getInstance<T>() as T;
//       }
//     }

//     return null;
//   }

//   // static ReactterProviderState? of(BuildContext context) {
//   //   return context.findAncestorStateOfType<ReactterProviderState>();
//   // }

//   static ReactterProviderState? of(
//     BuildContext context, {
//     bool listen = false,
//     Object? aspect,
//   }) {
//     return listen
//         ? context
//             .dependOnInheritedWidgetOfExactType<
//                 ReactterInheritedWidget<ReactterProviderState>>(aspect: aspect)
//             ?.data
//         : context.findAncestorStateOfType<ReactterProviderState>();
//   }

//   @override
//   State<ReactterProvider> createState() => ReactterProviderState();
// }

// class ReactterProviderState extends State<ReactterProvider> {
//   List<_ReactterContext>? contexts;
//   Map<Type, Object?>? instanceMapper;

//   @override
//   initState() {
//     super.initState();

//     contexts = widget.contexts;

//     for (var _context in contexts!) {
//       _context.initialize(true);

//       instanceMapper ??= {};
//       instanceMapper?[_context.instance.runtimeType] = _context.instance;

//       if (_context.instance is ReactterStates) {
//         final instance = _context.instance as ReactterStates;
//         instance.whenChanged = () => setState(() {});
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ReactterInheritedWidget<ReactterProviderState>(
//       child: Builder(builder: (context) {
//         return widget.builder(context);
//       }),
//       data: this,
//     );
//     // return Builder(builder: (context) {
//     //   return widget.builder(context);
//     // });
//   }

//   @override
//   dispose() {
//     contexts = widget.contexts as List<ReactterContext>;

//     for (var controller in contexts!) {
//       print('[REACTTER] Instance "' +
//           controller.instance.runtimeType.toString() +
//           '" with hashcode: ' +
//           controller.hashCode.toString() +
//           ' has been disposed');

//       controller.destroy();
//     }

//     super.dispose();
//   }

//   T? getInstance<T>() {
//     return instanceMapper?[T] as T?;
//   }
// }

// class ReactterInheritedWidget<T> extends InheritedWidget {
//   final T data;

//   const ReactterInheritedWidget({
//     Key? key,
//     required Widget child,
//     required this.data,
//   }) : super(key: key, child: child);

//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     return true;
//   }
// }

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
    (widget.owner as UseProvider).setRebuilds(this);

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

  @override
  void didChangeDependencies() {
    // _isBuildFromExternalSources = true;
    super.didChangeDependencies();
  }

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
    super.unmount();
  }

  // @override
  // bool get hasValue => _delegateState.hasValue;

  // @override
  void markNeedsNotifyDependents() {
    // if (!_isNotifyDependentsEnabled) {
    //   return;
    // }

    markNeedsBuild();
    _shouldNotifyDependents = true;
  }

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
