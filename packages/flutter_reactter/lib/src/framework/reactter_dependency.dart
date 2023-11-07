part of '../framework.dart';

abstract class ReactterDependency {
  // ignore: prefer_final_fields
  Object? _instance;
  final Set<ReactterState> _states;

  ReactterDependency(this._instance, this._states);

  ReactterMasterDependency makeMaster();
}

class ReactterInstanceDependency extends ReactterDependency {
  ReactterInstanceDependency(Object instance) : super(instance, const {});

  @override
  ReactterMasterDependency makeMaster() => ReactterMasterDependency(
        instance: _instance,
      );
}

class ReactterStatesDependency extends ReactterDependency {
  ReactterStatesDependency(Set<ReactterState> states) : super(null, states);

  @override
  ReactterMasterDependency makeMaster() => ReactterMasterDependency(
        states: _states,
      );
}

class ReactterSelectDependency extends ReactterDependency {
  ReactterSelectDependency({
    Object? instance,
    Set<ReactterState> states = const {},
    required SelectComputeValue computeValue,
  }) : super(instance, states);

  @override
  ReactterMasterDependency makeMaster() => ReactterMasterDependency(
        selects: {this},
      );
}

class ReactterMasterDependency extends ReactterDependency {
  final Set<ReactterSelectDependency> selects;

  ReactterMasterDependency({
    Object? instance,
    Set<ReactterState> states = const {},
    this.selects = const {},
  }) : super(instance, states);

  void putDependency(ReactterDependency dependency) {
    if (dependency is ReactterInstanceDependency) {
      _instance = dependency._instance;
      return;
    }
    if (dependency is ReactterStatesDependency) {
      _states.addAll(dependency._states);
      return;
    }
  }

  @override
  ReactterMasterDependency makeMaster() {
    throw UnimplementedError();
  }
}
