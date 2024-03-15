part of 'signal.dart';

/// This enumeration is used to represent different events that can occur when
/// getting or setting the value of a `Signal` object.
enum SignalEvent { onGetValue, onSetValue }

/// {@template signal}
/// A base-class that store a value of [T] and notify the listeners
/// when the value is updated.
///
/// You can create a new [Signal]:
///
/// ```dart
/// // usign the `Signal` class
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
/// {@endtemplate}
class Signal<T> extends ReactterStateImpl with ObjBase<T> implements Obj<T> {
  T _value;

  /// {@macro signal}
  Signal(T value) : _value = value;

  bool _shouldGetValueNotify = true;
  bool _shouldSetValueNotify = true;

  /// Returns the [value] of the signal.
  @override
  T get value {
    _notifyGetValue();

    return _value;
  }

  /// Updates the [value] of the signal
  /// and notifies the observers when changes occur.
  @override
  set value(T val) {
    if (_value == val) return;

    update((_) {
      _value = val;
      _notifySetValue();
    });
  }

  /// Gets and/or sets to [value] like a function
  /// This method doesn't allow setting its value to null.
  /// If you need to set null as value, use `.value = null`.
  @override
  T call([T? val]) {
    assert(!isDisposed, "You can call when it's been disposed");

    if (val != null) value = val;

    return value;
  }

  @override
  void update(void Function(T value) fnUpdate) {
    super.update(() => fnUpdate(value));
  }

  void _notifyGetValue() {
    if (!_shouldGetValueNotify) return;

    _shouldGetValueNotify = false;
    Reactter.emit(Signal, SignalEvent.onGetValue, this);
    _shouldGetValueNotify = true;
  }

  void _notifySetValue() {
    if (!_shouldSetValueNotify) return;

    _shouldSetValueNotify = false;
    Reactter.emit(Signal, SignalEvent.onSetValue, this);
    _shouldSetValueNotify = true;
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

extension ObjToSignalExt<T> on Obj<T> {
  /// Returns a new Signal<T> with the value of the current Obj<T>.
  Signal<T> get toSignal => Signal<T>(value);
}

extension SignalToObjExt<T> on Signal<T> {
  /// Returns a new Obj<T> with the value of the current Signal<T>.
  Obj<T> get toObj => Obj<T>(value);
}
