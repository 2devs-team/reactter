part of '../framework.dart';

abstract class ReactterDependency<T extends Object?> {
  T? _instance;
  final Set<ReactterState> _states;

  ReactterDependency(this._instance, this._states);

  ReactterMasterDependency<T> makeMaster();
}

class ReactterInstanceDependency<T extends Object?>
    extends ReactterDependency<T> {
  ReactterInstanceDependency(T instance) : super(instance, const {});

  @override
  ReactterMasterDependency<T> makeMaster() => ReactterMasterDependency<T>(
        instance: _instance,
      );
}

class ReactterStatesDependency<T extends Object?>
    extends ReactterDependency<T> {
  ReactterStatesDependency(Set<ReactterState> states) : super(null, states);

  @override
  ReactterMasterDependency<T> makeMaster() => ReactterMasterDependency<T>(
        states: _states,
      );
}

class ReactterSelectDependency<T extends Object?>
    extends ReactterDependency<T> {
  final T _instanceSelect;
  final Selector<T, dynamic> computeValue;
  late final dynamic value;

  ReactterSelectDependency({
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

  S watchState<S extends ReactterState>(S state) {
    _states.add(state);
    return state;
  }

  static S skipWatchState<S extends ReactterState>(S s) => s;

  @override
  ReactterMasterDependency<T> makeMaster() => ReactterMasterDependency<T>(
        selects: {this},
      );
}

class ReactterMasterDependency<T extends Object?>
    extends ReactterDependency<T> {
  final Set<ReactterSelectDependency> _selects;

  ReactterMasterDependency({
    T? instance,
    Set<ReactterState> states = const {},
    Set<ReactterSelectDependency> selects = const {},
  })  : _selects = selects.toSet(),
        super(instance, states.toSet());

  void putDependency(ReactterDependency dependency) {
    if (dependency is ReactterInstanceDependency) {
      _instance = dependency._instance as T;
      return;
    }

    if (dependency is ReactterStatesDependency) {
      _states.addAll(dependency._states);
      return;
    }

    if (dependency is ReactterSelectDependency) {
      _instance = dependency._instance as T;
      _selects.add(dependency);
    }
  }

  // coverage:ignore-start
  @override
  ReactterMasterDependency<T> makeMaster() {
    throw UnimplementedError();
  }
  // coverage:ignore-end
}
