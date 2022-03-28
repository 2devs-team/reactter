library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_types.dart';
import 'package:reactter/hooks/reactter_use_state.dart';
import 'package:reactter/engine/reactter_interface_instance.dart';
import 'package:reactter/widgets/reactter_use_provider.dart';

abstract class UseContextAbstraction<T extends Object> {
  T? get instance;

  void initialize([bool init = false]);
  void destroy();
}

class UseContext<T extends Object> extends UseContextAbstraction {
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
      List<dynamic>? _valueStates;

      _instance = UseProvider.of<T>(this, listen: true, aspect: (_) {
        final _valueStatesToCompared = selector(_instance!);

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

  T static<T>() => UseProvider.of<T>(this)!;
}
