part of 'obj.dart';

/// {@template reactter.obj}
/// A base-class that store a value of [T].
///
/// You can create a new [Obj]:
///
/// ```dart
/// // usign the `Obj` class
/// final strObj = Obj<String>("initial value");
/// final intObj = Obj<int>(0);
/// final userObj = Obj<User>(User());
/// ```
///
/// You can get the [value]:
///
/// ```dart
/// // usign a `value` getter
/// print(strObj.value);
/// // or using the callable
/// print(strObj());
/// // or using `toString` implicit
/// print("$intObj");
/// ```
///
/// You can set a new [value]:
///
/// ```dart
/// // usign a `value` setter
/// strObj.value = "change value";
/// // or using the callable
/// strObj("change value");
/// ```
/// {@endtemplate}
@Deprecated(
  'This feature was deprecated after v7.2.0 and will be removed in v8.0.0.',
)
class Obj<T> with ObjBase<T> {
  @override
  T value;

  /// {@macro reactter.obj}
  Obj(this.value);
}

abstract class ObjBase<T> {
  set value(T value);
  T get value;

  /// The equality operator.
  ///
  /// It's checking if the [other] object is of the same type as the [Obj], if it is, it compares the
  /// [value], else it compares like [Object] using [hashCode].
  ///
  /// Examples:
  /// ```dart
  /// final obj = Obj(0);
  /// final obj2 = Obj(1);
  /// final obj3 = obj(0);
  /// final objCopy = obj;
  ///
  /// print(obj == 0); // true
  /// print(obj == 1); // false
  /// print(obj == obj2); // false
  /// print(obj == obj3); // true
  /// print(obj == objCopy); // true
  /// ```
  ///
  @override
  bool operator ==(Object other) =>
      other is Obj<T> ? identical(this, other) : value == other;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;

  /// Gets and/or sets to [value] like a function
  T call([T? val]) {
    if (null is T || val != null) {
      value = val as T;
    }

    return value;
  }

  @override
  String toString() => value.toString();
}

extension ObjNullExt<T> on Obj<T?> {
  /// Returns a new `Obj<T>` with the value of the current `Obj<T?>`
  /// if it's not null.
  Obj<T> get notNull {
    assert(value != null);
    return Obj<T>(value as T);
  }
}
