part of '../framework.dart';

abstract class ReactterDependency<T extends Object?> {
  // ignore: prefer_final_fields
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
  final T instance;
  late final dynamic value;
  final Selector<T, dynamic> computeValue;

  Set<ReactterState> get states => _states;

  ReactterSelectDependency({
    required this.instance,
    required this.computeValue,
  }) : super(null, {}) {
    value = resolve(true);
  }

  dynamic resolve([bool isWatchState = false]) {
    return computeValue(
      instance,
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
  final Set<ReactterSelectDependency<T>> _selects;

  ReactterMasterDependency({
    T? instance,
    Set<ReactterState> states = const {},
    Set<ReactterSelectDependency<T>> selects = const {},
  })  : _selects = selects,
        super(instance, states);

  void putDependency(ReactterDependency<T> dependency) {
    if (dependency is ReactterInstanceDependency) {
      _instance = dependency._instance;
      return;
    }
    if (dependency is ReactterStatesDependency) {
      _states.addAll(dependency._states);
      return;
    }

    if (dependency is ReactterSelectDependency) {
      _selects.add(dependency as ReactterSelectDependency<T>);
    }
  }

  @override
  ReactterMasterDependency<T> makeMaster() {
    throw UnimplementedError();
  }
}
