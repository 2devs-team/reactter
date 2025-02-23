import 'dart:math';
import 'package:reactter/src/framework.dart';

part 'extensions/signal_bigint.dart';
part 'extensions/signal_bool.dart';
part 'extensions/signal_date_time.dart';
part 'extensions/signal_double.dart';
part 'extensions/signal_int.dart';
part 'extensions/signal_iterable.dart';
part 'extensions/signal_list.dart';
part 'extensions/signal_map.dart';
part 'extensions/signal_num.dart';
part 'extensions/signal_set.dart';
part 'extensions/signal_string.dart';

/// This enumeration is used to represent different events that can occur when
/// getting or setting the value of a `Signal` object.
enum SignalEvent { onGetValue, onSetValue }

/// {@template reactter.signal}
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
/// Rt.on(
///   strSignal,
///   Lifecycle.willUpdate,
///   (signal, _) => print("Previous value: $signal"),
/// );
///
/// Rt.on(
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
/// {@endtemplate}
class Signal<T> with RtState {
  bool _shouldGetValueNotify = true;
  bool _shouldSetValueNotify = true;

  T _value;
  final String? _debugLabel;

  @override
  String? get debugLabel => _debugLabel ?? super.debugLabel;

  @override
  Map<String, dynamic> get debugInfo => {'value': value};

  /// Returns the [value] of the signal.
  T get value {
    _notifyGetValue();

    return _value;
  }

  /// Updates the [value] of the signal
  /// and notifies the observers when changes occur.
  set value(T val) {
    if (_value == val) return;

    update((_) {
      _value = val;
      _notifySetValue();
    });
  }

  /// {@macro reactter.signal}
  Signal._(
    T value, {
    String? debugLabel,
  })  : _value = value,
        _debugLabel = debugLabel;

  factory Signal(T value, {String? debugLabel}) {
    return Rt.registerState(() => Signal._(value, debugLabel: debugLabel));
  }

  /// Gets and/or sets to [value] like a function
  /// This method doesn't allow setting its value to null.
  /// If you need to set null as value, use `.value = null`.
  T call([T? val]) {
    assert(!isDisposed, "You can call when it's been disposed");

    if (val != null) value = val;

    return value;
  }

  /// Executes [callback], and notifies the listeners about the update.
  @override
  void update(void Function(T value) fnUpdate) {
    super.update(() => fnUpdate(value));
  }

  @override
  String toString() => value.toString();

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  /// The equality operator.
  ///
  /// It's checking if the [other] object is of the same type as the [Signal],
  /// if it is, it compares the [value], else it compares like [Object] using [hashCode].
  ///
  /// Examples:
  /// ```dart
  /// final s = Signal(0);
  /// final s2 = Signal(1);
  /// final s3 = s(0);
  /// final sCopy = s;
  ///
  /// print(s == 0); // true
  /// print(s == 1); // false
  /// print(s == s2); // false
  /// print(s == s3); // true
  /// print(s == sCopy); // true
  /// ```
  ///
  @override
  bool operator ==(Object other) =>
      other is Signal<T> ? identical(this, other) : value == other;

  void _notifyGetValue() {
    if (!_shouldGetValueNotify) return;

    _shouldGetValueNotify = false;
    Rt.emit(Signal, SignalEvent.onGetValue, this);
    _shouldGetValueNotify = true;
  }

  void _notifySetValue() {
    if (!_shouldSetValueNotify) return;

    _shouldSetValueNotify = false;
    Rt.emit(Signal, SignalEvent.onSetValue, this);
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
