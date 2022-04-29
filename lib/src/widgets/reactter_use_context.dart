library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/src/core/reactter_context.dart';
import '../core/reactter_types.dart';
import '../engine/reactter_interface_instance.dart';
import '../widgets/reactter_use_provider.dart';

abstract class UseContextAbstraction<T extends ReactterContext> {
  T? get instance;

  String? get id;

  UseContextAbstraction();

  void initialize([bool init = false]);

  @protected
  void destroy();
}

/// Takes a instance of [ReactterContext] class defined on firts parameter `instanceBuilder`
/// and manages it like a context.
///
/// It's necessary use it inside `contexts` of [UseProvider].
///
/// ```dart
/// UseProvider(
///  contexts: [
///    UseContext(
///      () => AppContext(),
///    ),
///  ],
/// )
/// ```
class UseContext<T extends ReactterContext> extends UseContextAbstraction {
  /// Create a instances of [ReactterContext] class
  final InstanceBuilder<T> instanceBuilder;

  /// Id usted to identify the context
  @override
  final String? id;

  /// Create the instance defined on firts parameter `instanceBuilder` when [UseContext] is called.
  final bool init;

  /// Invoked when instance defined on firts parameter `instanceBuilder` is created
  final void Function(T instance)? onInit;

  /// Contain a instance of [ReactterContext] class
  @override
  T? instance;

  UseContext(
    this.instanceBuilder, {
    this.id,
    this.init = false,
    this.onInit,
  }) : super() {
    Reactter.factory.register<T>(instanceBuilder, id);

    initialize(init);
  }

  /// Executes to intitialize the instance and save it in `instance`
  @override
  @protected
  initialize([bool init = false]) {
    if (init) return;

    instance ??= Reactter.factory.getInstance<T>(id);

    if (instance != null) {
      onInit?.call(instance!);
    }
  }

  /// Executes when the `instance` is no longer required
  @override
  @protected
  destroy() {
    if (instance == null) return;

    Reactter.factory.deleted(instance!);
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
