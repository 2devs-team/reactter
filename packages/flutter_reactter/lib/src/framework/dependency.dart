part of '../framework.dart';

abstract class Dependency<T extends Object?> {
  T? _instance;
  final Set<RtState> _states;
  bool _isDirty = false;
  bool get isDirty => _isDirty;
  CallbackEvent? _listener;

  Dependency(this._instance, this._states) {
    listen(markDirty);
  }

  MasterDependency<T> toMaster();

  void commitToMaster(MasterDependency<T> masterDependency);

  @mustCallSuper
  void markDirty() {
    _isDirty = true;
    unlisten();
  }

  void listen(covariant void Function() callback);

  @mustBeOverridden
  @mustCallSuper
  void unlisten() {
    _listener = null;
  }

  @mustCallSuper
  void dispose() {
    unlisten();
  }

  CallbackEvent _buildListenerCallback(void Function() callback) {
    unlisten();

    return _listener = (instanceOrState, _) {
      callback();
      markDirty();
      unlisten();
    };
  }
}

class MasterDependency<T extends Object?> extends Dependency<T> {
  final Set<SelectDependency> _selects;

  MasterDependency({
    T? instance,
    Set<RtState> states = const {},
    Set<SelectDependency> selects = const {},
  })  : _selects = selects.toSet(),
        super(instance, states.toSet());

  void putDependency(Dependency<T> dependency) {
    dependency.commitToMaster(this);
  }

  @override
  void dispose() {
    unlisten();

    for (final select in _selects) {
      select.unlisten();
    }

    super.dispose();
  }

  @override
  void listen(void Function() callback) {
    final eventListener = _buildListenerCallback(callback);

    if (_instance != null) {
      Rt.on(_instance, Lifecycle.didUpdate, eventListener);
    }

    for (final state in _states) {
      Rt.on(state, Lifecycle.didUpdate, eventListener);
    }

    for (final select in _selects) {
      select.listen(callback);
    }
  }

  @override
  void unlisten() {
    if (_listener == null) return;

    if (_instance != null) {
      Rt.off(_instance, Lifecycle.didUpdate, _listener!);
    }

    for (final state in _states) {
      Rt.off(state, Lifecycle.didUpdate, _listener!);
    }

    super.unlisten();
  }

  // coverage:ignore-start
  @override
  void commitToMaster(MasterDependency<T> masterDependency) {
    assert(true, 'This method should not be called');
  }
  // coverage:ignore-end

  // coverage:ignore-start
  @override
  MasterDependency<T> toMaster() => this;
  // coverage:ignore-end
}

class InstanceDependency<T extends Object?> extends Dependency<T> {
  InstanceDependency(T instance) : super(instance, const {});

  @override
  MasterDependency<T> toMaster() {
    final masterDependency = MasterDependency<T>(
      instance: _instance,
    );

    if (isDirty) masterDependency.markDirty();

    return masterDependency;
  }

  @override
  void commitToMaster(MasterDependency<T> masterDependency) {
    if (_instance != null) masterDependency._instance = _instance;
  }

  @override
  void listen(void Function() callback) {
    final eventListener = _buildListenerCallback(callback);

    Rt.on(_instance, Lifecycle.didUpdate, eventListener);
  }

  @override
  void unlisten() {
    if (_listener == null) return;

    Rt.off(_instance, Lifecycle.didUpdate, _listener!);
    super.unlisten();
  }
}

class StatesDependency<T extends Object?> extends Dependency<T> {
  StatesDependency(Set<RtState> states) : super(null, states);

  @override
  MasterDependency<T> toMaster() {
    final masterDependency = MasterDependency<T>(
      states: _states,
    );

    if (isDirty) masterDependency.markDirty();

    return masterDependency;
  }

  @override
  void commitToMaster(MasterDependency<T> masterDependency) {
    masterDependency._states.addAll(_states);
  }

  @override
  void listen(void Function() callback) {
    final eventListener = _buildListenerCallback(callback);

    for (final state in _states) {
      Rt.on(state, Lifecycle.didUpdate, eventListener);
    }
  }

  @override
  void unlisten() {
    if (_listener == null) return;

    for (final state in _states) {
      Rt.off(state, Lifecycle.didUpdate, _listener!);
    }

    super.unlisten();
  }
}

class SelectDependency<T extends Object?> extends Dependency<T> {
  final T instanceSelect;
  final Selector<T, dynamic> computeValue;
  late final dynamic value;

  SelectDependency({
    required T instance,
    required this.computeValue,
  })  : instanceSelect = instance,
        super(null, {}) {
    value = resolve(true);
    if (_states.isEmpty) _instance = instance;
  }

  dynamic resolve([bool isWatchState = false]) {
    return computeValue(
      instanceSelect,
      isWatchState ? watchState : skipWatchState,
    );
  }

  S watchState<S extends RtState>(S state) {
    _states.add(state);
    return state;
  }

  S skipWatchState<S extends RtState>(S s) => s;

  @override
  MasterDependency<T> toMaster() {
    return MasterDependency<T>(selects: {this});
  }

  @override
  void commitToMaster(MasterDependency<T> masterDependency) {
    if (_instance != null) masterDependency._instance = _instance;

    masterDependency._selects.add(this);
  }

  @override
  CallbackEvent _buildListenerCallback(void Function() callback) {
    unlisten();

    return _listener = (instanceOrState, _) {
      if (value == resolve()) return;

      callback();
      markDirty();
      unlisten();
    };
  }

  @override
  void listen(void Function() callback) {
    final eventListener = _buildListenerCallback(callback);

    if (_instance != null) {
      Rt.on(_instance, Lifecycle.didUpdate, eventListener);
    }

    for (final state in _states) {
      Rt.on(state, Lifecycle.didUpdate, eventListener);
    }
  }

  @override
  void unlisten() {
    if (_listener == null) return;

    if (_instance != null) {
      Rt.off(_instance, Lifecycle.didUpdate, _listener!);
    }

    for (final state in _states) {
      Rt.off(state, Lifecycle.didUpdate, _listener!);
    }

    super.unlisten();
  }
}
