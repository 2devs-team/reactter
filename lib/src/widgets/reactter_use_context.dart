library reactter;

import 'package:flutter/widgets.dart';
import '../core/mixins/reactter_life_cycle.dart';
import '../core/reactter_context.dart';
import '../core/reactter_types.dart';
import '../engine/reactter_interface_instance.dart';
import '../widgets/reactter_use_provider.dart';

abstract class UseContextAbstraction<T extends ReactterContext> {
  T? get instance;

  String? get id;

  UseContextAbstraction();

  void initialize([bool init = false]);

  void destroy();
}

/// Takes a instance of [ReactterContext] class defined
/// on firts parameter [instanceBuilder] and manages it like a context.
///"
/// It's necessary use it inside [contexts] of [UseProvider] :
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
  @protected
  final InstanceBuilder<T> instanceBuilder;

  /// Id usted to identify the context
  @override
  final String? id;

  /// Create the instance defined on firts parameter `instanceBuilder` when [UseContext] is called.
  @protected
  final bool init;

  /// Invoked when instance defined on firts parameter `instanceBuilder` is created
  @protected
  final void Function(T instance)? onInit;

  /// Contain a instance of [ReactterContext] class
  @override
  @protected
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

  /// Executes to intitialize the instance and save it in [instance].
  ///
  /// Fires lifecycle [awake] when instance is created.
  @override
  @protected
  initialize([bool init = false]) {
    if (!init) return;

    instance ??= Reactter.factory.getInstance<T>(id);
    instance?.executeEvent(EVENT_TYPE.awake);

    if (instance != null) {
      onInit?.call(instance!);
    }
  }

  /// Executes when the `instance` is no longer required
  @override
  @protected
  destroy() {
    if (instance == null) return;

    instance?.executeEvent(EVENT_TYPE.willUnmount);
    Reactter.factory.deleted(instance!);
  }
}
