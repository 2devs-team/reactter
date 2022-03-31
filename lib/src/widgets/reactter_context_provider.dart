library reactter;

import '../engine/reactter_interface_instance.dart';

class ContextProvider<T extends Object> {
  final String id;
  final Type type = T;
  final T Function() constructor;
  T? instance;
  final bool init;
  final bool create;

  ContextProvider(
    this.constructor, {
    this.init = false,
    this.create = false,
    this.id = "",
  }) {
    Reactter.factory.register<T>(constructor);

    initialize(init);
  }

  initialize([bool init = false]) {
    if (!init) return;

    if (instance != null) return;

    instance = Reactter.factory.getInstance<T>(create, 'ContextProvider');
  }

  destroy() {
    if (instance == null) return;

    Reactter.factory.deleted(instance!);
  }
}
