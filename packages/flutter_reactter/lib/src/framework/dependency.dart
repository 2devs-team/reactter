part of '../framework.dart';

abstract class Dependency<T extends Object?> {
  T? _instance;
  final Set<RtState> _states;

  Dependency(this._instance, this._states);

  MasterDependency<T> makeMaster();
}

class MasterDependency<T extends Object?> extends Dependency<T> {
  final Set<SelectDependency> _selects;

  MasterDependency({
    T? instance,
    Set<RtState> states = const {},
    Set<SelectDependency> selects = const {},
  })  : _selects = selects.toSet(),
        super(instance, states.toSet());

  void putDependency(Dependency dependency) {
    if (dependency is InstanceDependency) {
      _instance = dependency._instance as T;
      return;
    }

    if (dependency is StatesDependency) {
      _states.addAll(dependency._states);
      return;
    }

    if (dependency is SelectDependency) {
      _instance = dependency._instance as T;
      _selects.add(dependency);
    }
  }

  // coverage:ignore-start
  @override
  MasterDependency<T> makeMaster() {
    throw UnimplementedError();
  }
  // coverage:ignore-end
}

class InstanceDependency<T extends Object?> extends Dependency<T> {
  InstanceDependency(T instance) : super(instance, const {});

  @override
  MasterDependency<T> makeMaster() => MasterDependency<T>(
        instance: _instance,
      );
}

class StatesDependency<T extends Object?> extends Dependency<T> {
  StatesDependency(Set<RtState> states) : super(null, states);

  @override
  MasterDependency<T> makeMaster() => MasterDependency<T>(
        states: _states,
      );
}

class SelectDependency<T extends Object?> extends Dependency<T> {
  final T _instanceSelect;
  final Selector<T, dynamic> computeValue;
  late final dynamic value;

  SelectDependency({
    required T instance,
    required this.computeValue,
  })  : _instanceSelect = instance,
        super(null, {}) {
    value = resolve(true);
    if (_states.isEmpty) _instance = instance;
  }

  dynamic resolve([bool isWatchState = false]) {
    return computeValue(
      _instanceSelect,
      isWatchState ? watchState : skipWatchState,
    );
  }

  S watchState<S extends RtState>(S state) {
    _states.add(state);
    return state;
  }

  static S skipWatchState<S extends RtState>(S s) => s;

  @override
  MasterDependency<T> makeMaster() => MasterDependency<T>(
        selects: {this},
      );
}
