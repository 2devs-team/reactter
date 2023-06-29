part of '../core.dart';

/// This enumeration is used to represent different events that can occur when
/// getting or setting the value of a `Signal` object.
enum SignalEvent { onGetValue, onSetValue }

/// A base-class that store a value of [T] and notify the listeners
/// when the value is updated.
///
/// You can create a new [Signal]:
///
/// ```dart
/// // usign `.signal` extension
/// final strSignal = "initial value".signal;
/// final intSignal = 0.signal;
/// final userSignal = User().signal;
/// // or usign the constructor class
/// final strSignal = Signal<String>("initial value");
/// final intSignal = Signal<int>(0);
/// final userSignal = Signal<User>(User());
/// ```
///
/// You can get the [value]:
///
/// ```dart
/// // usign a `value` getter
/// print(strSignal.value);
/// // or using the callable
/// print(strSignal());
/// // or using `toString` implicit
/// print("$intSignal");
/// ```
///
/// You can set a new [value]:
///
/// ```dart
/// // usign a `value` setter
/// strSignal.value = "change value";
/// // or using the callable
/// strSignal("change value");
/// ```
///
/// You can use `Lifecycle.willUpdate` event for before the [value] is changed,
/// or use `Lifecicle.didUpdate` event for after the [value] is changed:
///
/// ```dart
/// Reactter.on(
///   strSignal,
///   Lifecycle.willUpdate,
///   (signal, _) => print("Previous value: $signal"),
/// );
///
/// Reactter.on(
///   strSignal,
///   Lifecycle.didUpdate,
///   (signal, _) => print("Current value: $signal"),
/// );
/// ```
///
/// Use `update` method to notify changes after run a set of instructions:
///
/// ```dart
/// userSignal.update((user) {
///   user.firstname = "Leo";
///   user.lastname = "Leon";
/// });
/// ```
///
/// Use `refresh` method to force to notify changes.
///
/// ```dart
/// userSignal.refresh();
/// ```
///
/// If you use flutter, add [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
/// package on your dependencies and use its Widgets.
///
/// See also:
///
/// * [Obj], a base-class that can be used to store a value of [T].
class Signal<T> extends Obj<T> with ReactterState {
  Signal(T initial) : super(initial) {
    createState();
  }

  bool _shouldGetValueNotify = true;
  bool _shouldSetValueNotify = true;

  /// Returns the [value] of the signal.
  T get value {
    if (_shouldGetValueNotify) {
      _shouldGetValueNotify = false;
      Reactter.emit(Signal, SignalEvent.onGetValue, this);
      _shouldGetValueNotify = true;
    }

    return super.value;
  }

  /// Updates the [value] of the signal
  /// and notifies the observers when changes occur.
  set value(T val) {
    if (super.value == val) return;

    update((_) {
      super.value = val;

      if (!_shouldSetValueNotify) return;

      _shouldSetValueNotify = false;
      Reactter.emit(Signal, SignalEvent.onSetValue, this);
      _shouldSetValueNotify = true;
    });
  }

  /// Gets and/or sets to [value] like a function
  /// This method doesn't allow setting its value to null.
  /// If you need to set null as value, use `.value = null`.
  T call([T? val]) {
    assert(!_isDisposed, "You can call when it's been disposed");

    if (val != null) value = val;

    return value;
  }

  /// Executes [fnUpdate], and notify the listeners about to update.
  void update(void fnUpdate(T value)) {
    super.update(() => fnUpdate(value));
  }

  /// Executes [fnUpdate], and notify the listeners about to update as async way.
  Future<void> updateAsync(void fnUpdate(value)) async {
    await super.updateAsync(() => fnUpdate(value));
  }
}

extension SignalNullExt<T> on Signal<T?> {
  /// Returns a new `Signal<T>` with the value of the current `Signal<T?>`
  /// if it's not null.
  Signal<T> get notNull {
    assert(value != null);
    return Signal<T>(value as T);
  }
}

extension SignalGenericTypeExt<T> on T {
  /// Allows you to create a signal from any type.
  Signal<T> get signal => Signal<T>(this);
}

extension ObjToSignalExt<T> on Obj<T> {
  /// Returns a new Signal<T> with the value of the current Obj<T>.
  Signal<T> get toSignal => Signal<T>(value);
}

extension SignalToObjExt<T> on Signal<T> {
  /// Returns a new Obj<T> with the value of the current Signal<T>.
  Obj<T> get toObj => Obj<T>(value);
}
