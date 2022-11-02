part of '../../core.dart';

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
  /// final obj2 = Obj(0);
  /// final obj3 = obj;
  ///
  /// print(obj == 0); // true
  /// print(obj == 1); // false
  /// print(obj == obj); // true
  /// print(obj == obj2); // false
  /// print(obj == obj3); // true
  /// ```
  ///
  bool operator ==(Object other) =>
      other is Obj<T> ? value == other.value : value == other;

  /// Gets and/or sets to [value] like a function
  T call([T? val]) {
    if (null is T || val != null) {
      value = val as T;
    }

    return value;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => value.toString();
}

extension ObjNullExt<T> on Obj<T?> {
  Obj<T> get notNull => Obj<T>(value!);
}

extension ObjGenericTypeExt<T> on T {
  Obj<T> get obj => Obj<T>(this);
}
