part of '../../core.dart';

class Signal<T> extends Obj<T> with ReactterNotifyManager, ReactterState {
  T _value;

  /// Returns the [value] of the signal.
  T get value {
    Reactter.signalProxy?.addSignal(this);
    return _value;
  }

  /// Updates the [value] of the signal
  /// and notifies the observers when changes occur.
  set value(T val) {
    if (_value == val) return;

    update((_) => _value = val);
  }

  Signal(T initial)
      : _value = initial,
        super(initial) {
    /// Sure that the signals are collected when the instance is created.
    if (Reactter._instancesBuilding) {
      Reactter._signalsRecollected.add(this);
    }
  }

  /// Gets and/or sets to [value] like a function
  T call([T? val]) {
    assert(!_isDisposed, "You can call when it's been disposed");

    if (null is T || val != null) {
      value = val as T;
    }

    return value;
  }

  /// Executes [fnUpdate], and notify the listeners about to update.
  void update(void fnUpdate(value)) {
    super.update(() => fnUpdate(value));
  }

  /// Executes [fnUpdate], and notify the listeners about to update as async way.
  Future<void> updateAsync(void fnUpdate(value)) async {
    await super.updateAsync(() => fnUpdate(value));
  }
}

extension SignalNullExt<T> on Signal<T?> {
  Signal<T> get notNull => Signal<T>(value!);
}

extension SignalGenericTypeExt<T> on T {
  Signal<T> get signal => Signal<T>(this);
}

extension ObjToSignalExt<T> on Obj<T> {
  Signal<T> get toSignal => Signal<T>(value);
}

extension SignalToObjExt<T> on Signal<T> {
  Obj<T> get toObj => Obj<T>(value);
}
