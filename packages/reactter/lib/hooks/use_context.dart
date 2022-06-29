part of '../hooks.dart';

class UseContext<T extends ReactterContext> extends ReactterHook {
  final String? id;

  T? _instance;
  T? get instance => _instance;

  UseContext([this.id]) : super(null) {
    _getInstance();

    if (instance != null) return;

    UseEvent<T>(id).on(LifeCycleEvent.willMount, _onInstanceDidMount);
  }

  void _getInstance() {
    update(() {
      _instance = Reactter.factory.getInstance<T>(id, this);
    });
  }

  void _onInstanceDidMount(inst, param) {
    update(() {
      _instance = inst;
      UseEvent<T>(id).off(LifeCycleEvent.willMount, _onInstanceDidMount);
    });
  }
}
