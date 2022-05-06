library reactter;

import 'package:flutter/widgets.dart';
import '../core/reactter_types.dart';
import '../core/mixins/reactter_life_cycle.dart';
import '../core/reactter_context.dart';
import '../engine/reactter_interface_instance.dart';
import '../engine/reactter_inherit_provider.dart';
import '../engine/reactter_inherit_provider_scope.dart';
import '../engine/reactter_inherit_provider_scope_element.dart';
import '../widgets/reactter_use_context.dart';

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
    for (var i = 0; i < contexts.length; i++) {
      final _context = contexts[i];

      _context.initialize(true);

      if (_context.instance is ReactterContext) {
        (_context.instance as ReactterContext).executeEvent(EVENT_TYPE.awake);
      }
    }
  }

  /// Iterates his children to set an action in every state.
  _iterateContextWithInherit(
      ReactterInheritedProviderScopeElement inheritedElement,
      Function(ReactterContext) action) {
    for (var i = 0; i < contexts.length; i++) {
      if (contexts[i].instance is ReactterContext) {
        final instance = contexts[i].instance as ReactterContext;

        action(instance);
      }
    }
  }

  /// Executes all [willMount] from every [ReactterContext] in his children.
  willMount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance.executeEvent(EVENT_TYPE.willMount);
    });
  }

  /// Executes all [didMount] methods from every [ReactterContext] in his children and add
  /// the [markNeedsBuild] method to his listener for update when state change.
  didMount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance.executeEvent(EVENT_TYPE.didMount);
    });
  }

  /// Executes all [willUnmount] methods from every [ReactterContext] in his children and remove
  /// the [markNeedsBuild] method from his listener.
  willUnmount(ReactterInheritedProviderScopeElement inheritedElement) {
    _iterateContextWithInherit(inheritedElement, (instance) {
      instance.executeEvent(EVENT_TYPE.willUnmount);

      Reactter.factory.deleted(instance);
    });
  }

  /// Returns instance [ReactterContext] and context listens when call [markNeedsBuild]
  static T? of<T>(
    BuildContext context, {
    bool listen = false,
    SelectorAspect? aspect,
    String? id,
  }) {
    final _inheritedElement = _inheritedElementOf(context);
    final _instance = _getInstance<T>(context, id);

    if (listen) {
      if (_instance != null) {
        _inheritedElement?.dependOnInstance(_instance);
      }

      if (aspect != null) {
        context.dependOnInheritedElement(_inheritedElement!, aspect: aspect);
      } else {
        context.dependOnInheritedWidgetOfExactType<
            ReactterInheritedProviderScope>();
      }
    }

    return _instance;
  }

  static T? _getInstance<T>(BuildContext context, String? id) {
    T? instance;

    context.visitAncestorElements((parent) {
      final _inheritedElement = parent.getElementForInheritedWidgetOfExactType<
              ReactterInheritedProviderScope>()
          as ReactterInheritedProviderScopeElement?;

      final _contexts =
          (_inheritedElement?.widget.owner as UseProvider?)?.contexts;

      if (_contexts == null) return true;

      for (var i = 0; i < _contexts.length; i++) {
        final _useContext = _contexts[i];
        if (_useContext.type == T && _useContext.id == id) {
          instance = _useContext.instance as T?;
          break;
        }
      }

      return instance == null;
    });

    return instance;
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
}

/// In charge of return listeners of the given [ReactterContext].
///
/// This example use [of] to produce one context with all the listen state of [AppContext].
///
/// ```dart
///
/// final appContext = context.of<AppContext>();
///
/// Text(appContext.property.value);
///
///
/// ```
/// This example use [of] and [selector] to produce one context with just
/// the selected state of [AppContext]. You can use as many properties you need.
///
/// ```dart
///
/// final appContext = context.of<AppContext>((ctx) => [ctx.propToWatch1, ctx.propToWatch2]);
///
/// Text(appContext.propToWatch.value);
/// ```
///
/// This example use [ofStatic] to produce one context with all the static states of [AppContext].
/// This means that the widget doesn't rebuild when state change which improves performance.
///
/// ```dart
///
/// final appContext = context.ofStatic<AppContext>();
///
/// Text(appContext.property.value);
///
/// ```
///
/// This is usefull when you know the variable doesn't need to change.
extension ReactterBuildContextExtension on BuildContext {
  bool _validateAspectRebuild<T>(
    T instance,
    Selector<T> selector,
    List<dynamic>? valueStates,
  ) {
    final _valueStatesToCompared = selector(instance);

    /// If selector select nothing
    if (_valueStatesToCompared.isEmpty) return true;

    for (var index = 0; index <= _valueStatesToCompared.length - 1; index++) {
      if (_valueStatesToCompared[index].value != valueStates?[index]) {
        return true;
      }
    }

    return false;
  }

  List<dynamic>? _getValueStates<T>(T instance, Selector<T> selector) =>
      selector(instance).map((state) => state.value).toList();

  T _instanceController<T>({Selector<T>? selector, String? id}) {
    T? _instance;
    List<dynamic>? _valueStates;

    if (id != null) {
      if (selector == null) {
        _instance = UseProvider.of<T>(this, listen: true, id: id);
      } else {
        _instance = UseProvider.of<T>(
          this,
          id: id,
          listen: true,
          aspect: (_) =>
              _validateAspectRebuild<T>(_instance!, selector, _valueStates),
        );

        if (_instance != null) {
          _valueStates = _getValueStates(_instance, selector);
        }
      }

      assert(_instance != null,
          'Instance "$T" with id: "$id" does not exist in UseProvider');

      return _instance!;
    }

    if (selector == null) {
      _instance = UseProvider.of<T>(this, listen: true);
    } else {
      _instance = UseProvider.of<T>(
        this,
        listen: true,
        aspect: (_) =>
            _validateAspectRebuild<T>(_instance!, selector, _valueStates),
      );

      if (_instance != null) {
        _valueStates = _getValueStates<T>(_instance, selector);
      }
    }

    assert(_instance != null, 'Instance "$T" does not exist in UseProvider');

    return _instance!;
  }

  /// Returns all the listeners of the given [ReactterContext].
  /// This example produces one context with all the listen state of [AppContext].
  ///
  /// ```dart
  ///
  /// final appContext = context.of<AppContext>();
  ///
  /// Text(appContext.property.value);
  ///
  /// ```
  /// This example use [of] and [selector] to produce one context with just
  /// the selected state of [AppContext]. You can use as many properties you need.
  ///
  /// ```dart
  ///
  /// final appContext = context.of<AppContext>((ctx) => [ctx.propToWatch1, ctx.propToWatch2]);
  ///
  /// Text(appContext.propToWatch.value);
  /// ```
  ///
  T of<T>([Selector<T>? selector]) {
    T? _instance;

    if (selector == null) {
      _instance = UseProvider.of<T>(this, listen: true);
    } else {
      List<dynamic>? _valueStates;

      _instance = UseProvider.of<T>(this, listen: true, aspect: (_) {
        final _valueStatesToCompared = selector(_instance!);

        /// If selector select nothing
        if (_valueStatesToCompared.isEmpty) return true;

        for (var index = 0;
            index <= _valueStatesToCompared.length - 1;
            index++) {
          if (_valueStatesToCompared[index].value != _valueStates?[index]) {
            return true;
          }
        }

        return false;
      });

      if (_instance != null) {
        _valueStates = selector(_instance).map((state) => state.value).toList();
      }
    }

    assert(_instance != null,
        'Instance "$T" does not exist from contexts UseProviders');

    return _instance!;
  }

  /// Returns all the listeners of the given [ReactterContext] but just for read.
  /// This means that the widget doesn't rebuild when state change which improves performance.
  ///
  /// This example produces one context with all the static states of [AppContext].
  ///
  /// ```dart
  ///
  /// final appContext = context.ofStatic<AppContext>();
  ///
  /// Text(appContext.property.value);
  ///
  /// ```
  ///
  /// This is usefull when you know the variable doesn't need to change.
  T ofStatic<T>() => UseProvider.of<T>(this)!;

  T ofId<T>(String id, [Selector<T>? selector]) {
    //Cambiar a stateSelector ?
    return _instanceController(id: id, selector: selector);
  }

  T ofIdStatic<T>(String id) => UseProvider.of<T>(this, id: id)!;
}
