library reactter;

import 'package:flutter/material.dart';
import '../core/reactter_types.dart';
import '../hooks/reactter_use_state.dart';
import '../engine/reactter_interface_instance.dart';
import '../widgets/reactter_use_provider.dart';

abstract class UseContextAbstraction<T extends Object> {
  T? get instance;

  void initialize([bool init = false]);
  void destroy();
}

/// Save the state in memory from a [ReactterContext].
///
/// [create] is the builder function.
///
/// This widget always must be called inside [contexts] of [UseProvider].
///
/// This example produces one [UseContext] with an [AppContext] inside.
///
/// ```dart
/// UseProvider(
///  contexts: [
///    UseContext(
///      () => AppContext(),
///      init: true,
///    )
///  ]
/// )
/// ```
class UseContext<T extends Object> extends UseContextAbstraction {
  /// Id usted to identify the context
  final String? id;

  /// Initialize the context at the moment [UseContext] is called.
  final bool init;

  T? _instance;

  UseContext(
    BuilderContext<T> builderContext, {
    this.init = false,
    this.id,
  }) {
    Reactter.factory.register<T>(builderContext);

    initialize(init);
  }

  @override
  T? get instance => _instance;
  set instance(T? value) => _instance = value;

  /// Executes in constructor, intitialize the instance and save it in [_instance].
  @override
  initialize([bool init = false]) {
    if (!init) return;

    if (instance != null) return;

    instance = Reactter.factory.getInstance<T>(id: id);
  }

  @override
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
  T of<T>([List<UseState> Function(T instance)? selector]) {
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
}
