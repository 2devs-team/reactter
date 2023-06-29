part of '../core.dart';

/// A base-class that store a value of [T].
///
/// You can create a new [Obj]:
///
/// ```dart
/// // usign `.obj` extension
/// final strObj = "initial value".obj;
/// final intObj = 0.obj;
/// final userObj = User().obj;
/// // or usign the constructor class
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
class Obj<T> {
  T value;

  Obj(this.value);

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
  bool operator ==(Object other) =>
      other is Obj<T> ? value == other.value : value == other;

  int get hashCode => Object.hash(super.hashCode, super.hashCode);

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

extension ObjGenericTypeExt<T> on T {
  /// Allows you to call `.obj` on any object.
  Obj<T> get obj => Obj<T>(this);
}
