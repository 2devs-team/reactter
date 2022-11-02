// coverage:ignore-file
part of '../../core.dart';

extension ObjDoubleExt on Obj<double> {
  Obj<double> operator +(Obj<num> other) => (value + other.value).obj;

  Obj<double> operator -(Obj<num> other) => (value - other.value).obj;

  Obj<double> operator *(Obj<num> other) => (value * other.value).obj;

  Obj<double> operator %(Obj<num> other) => (value % other.value).obj;

  Obj<double> operator /(Obj<num> other) => (value / other.value).obj;

  Obj<int> operator ~/(Obj<num> other) => (value ~/ other.value).obj;

  Obj<double> operator -() => -value.obj;

  double remainder(num other) => value.remainder(other);

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `value`,
  /// the result is the same as `value < 0 ? -value : value`.
  ///
  /// Integer overflow may cause the result of `-value` to stay negative.
  double abs() => value.abs();

  /// The sign of the double's numerical value.
  ///
  /// Returns -1.0 if the value is less than zero,
  /// +1.0 if the value is greater than zero,
  /// and the value itself if it is -0.0, 0.0 or NaN.
  double get sign => value.sign;

  /// Returns the integer closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `Obj(3.5).round() == 4` and `Obj(-3.5).round() == -4`.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(Obj(3.0).round()); // 3
  /// print(Obj(3.25).round()); // 3
  /// print(Obj(3.5).round()); // 4
  /// print(Obj(3.75).round()); // 4
  /// print(Obj(-3.5).round()); // -4
  /// ```
  int round() => value.round();

  /// Returns the greatest integer no greater than this number.
  ///
  /// Rounds the number towards negative infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or infinity).
  /// ```dart
  /// print(Obj(1.99999).floor()); // 1
  /// print(Obj(2.0).floor()); // 2
  /// print(Obj(2.99999).floor()); // 2
  /// print(Obj(-1.99999).floor()); // -2
  /// print(Obj(-2.0).floor()); // -2
  /// print(Obj(-2.00001).floor()); // -3
  /// ```
  int floor() => value.floor();

  /// Returns the least integer that is not smaller than this number.
  ///
  /// Rounds the number towards infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(Obj(1.99999).ceil()); // 2
  /// print(Obj(2.0).ceil()); // 2
  /// print(Obj(2.00001).ceil()); // 3
  /// print(Obj(-1.99999).ceil()); // -1
  /// print(Obj(-2.0).ceil()); // -2
  /// print(Obj(-2.00001).ceil()); // -2
  /// ```
  int ceil() => value.ceil();

  /// Returns the integer obtained by discarding any fractional
  /// part of this number.
  ///
  /// Rounds the number towards zero.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(Obj(2.00001).truncate()); // 2
  /// print(Obj(1.99999).truncate()); // 1
  /// print(Obj(0.5).truncate()); // 0
  /// print(Obj(-0.5).truncate()); // 0
  /// print(Obj(-1.5).truncate()); // -1
  /// print(Obj(-2.5).truncate()); // -2
  /// ```
  int truncate() => value.truncate();

  /// Returns the integer double value closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `Obj(3.5).roundToDouble() == 4` and `Obj(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  /// ```dart
  /// print(Obj(3.0).roundToDouble()); // 3.0
  /// print(Obj(3.25).roundToDouble()); // 3.0
  /// print(Obj(3.5).roundToDouble()); // 4.0
  /// print(Obj(3.75).roundToDouble()); // 4.0
  /// print(Obj(-3.5).roundToDouble()); // -4.0
  /// ```
  double roundToDouble() => value.roundToDouble();

  /// Returns the greatest integer double value no greater than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `0.0 < d < 1.0` will return `0.0`.
  /// ```dart
  /// print(Obj(1.99999).floorToDouble()); // 1.0
  /// print(Obj(2.0).floorToDouble()); // 2.0
  /// print(Obj(2.99999).floorToDouble()); // 2.0
  /// print(Obj(-1.99999).floorToDouble()); // -2.0
  /// print(Obj(-2.0).floorToDouble()); // -2.0
  /// print(Obj(-2.00001).floorToDouble()); // -3.0
  /// ```
  double floorToDouble() => value.floorToDouble();

  /// Returns the least integer double value no smaller than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`.
  /// ```dart
  /// print(Obj(1.99999).ceilToDouble()); // 2.0
  /// print(Obj(2.0).ceilToDouble()); // 2.0
  /// print(Obj(2.00001).ceilToDouble()); // 3.0
  /// print(Obj(-1.99999).ceilToDouble()); // -1.0
  /// print(Obj(-2.0).ceilToDouble()); // -2.0
  /// print(Obj(-2.00001).ceilToDouble()); // -2.0
  /// ```
  double ceilToDouble() => value.ceilToDouble();

  /// Returns the integer double value obtained by discarding any fractional
  /// digits from `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`, and
  /// in the range `0.0 < d < 1.0` it will return 0.0.
  /// ```dart
  /// print(Obj(2.5).truncateToDouble()); // 2.0
  /// print(Obj(2.00001).truncateToDouble()); // 2.0
  /// print(Obj(1.99999).truncateToDouble()); // 1.0
  /// print(Obj(0.5).truncateToDouble()); // 0.0
  /// print(Obj(-0.5).truncateToDouble()); // -0.0
  /// print(Obj(-1.5).truncateToDouble()); // -1.0
  /// print(Obj(-2.5).truncateToDouble()); // -2.0
  /// ```
  double truncateToDouble() => value.truncateToDouble();
}

extension ObjDoubleNullExt on Obj<double?> {
  double? remainder(num other) => value?.remainder(other);

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `value`,
  /// the result is the same as `value < 0 ? -value : value`.
  ///
  /// Integer overflow may cause the result of `-value` to stay negative.
  double? abs() => value?.abs();

  /// The sign of the double's numerical value.
  ///
  /// Returns -1.0 if the value is less than zero,
  /// +1.0 if the value is greater than zero,
  /// and the value itself if it is -0.0, 0.0 or NaN.
  double? get sign => value?.sign;

  /// Returns the integer closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `Obj(3.5).round() == 4` and `Obj(-3.5).round() == -4`.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(Obj(3.0).round()); // 3
  /// print(Obj(3.25).round()); // 3
  /// print(Obj(3.5).round()); // 4
  /// print(Obj(3.75).round()); // 4
  /// print(Obj(-3.5).round()); // -4
  /// ```
  int? round() => value?.round();

  /// Returns the greatest integer no greater than this number.
  ///
  /// Rounds the number towards negative infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or infinity).
  /// ```dart
  /// print(Obj(1.99999).floor()); // 1
  /// print(Obj(2.0).floor()); // 2
  /// print(Obj(2.99999).floor()); // 2
  /// print(Obj(-1.99999).floor()); // -2
  /// print(Obj(-2.0).floor()); // -2
  /// print(Obj(-2.00001).floor()); // -3
  /// ```
  int? floor() => value?.floor();

  /// Returns the least integer that is not smaller than this number.
  ///
  /// Rounds the number towards infinity.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(Obj(1.99999).ceil()); // 2
  /// print(Obj(2.0).ceil()); // 2
  /// print(Obj(2.00001).ceil()); // 3
  /// print(Obj(-1.99999).ceil()); // -1
  /// print(Obj(-2.0).ceil()); // -2
  /// print(Obj(-2.00001).ceil()); // -2
  /// ```
  int? ceil() => value?.ceil();

  /// Returns the integer obtained by discarding any fractional
  /// part of this number.
  ///
  /// Rounds the number towards zero.
  ///
  /// Throws an [UnsupportedError] if this number is not finite
  /// (NaN or an infinity).
  /// ```dart
  /// print(Obj(2.00001).truncate()); // 2
  /// print(Obj(1.99999).truncate()); // 1
  /// print(Obj(0.5).truncate()); // 0
  /// print(Obj(-0.5).truncate()); // 0
  /// print(Obj(-1.5).truncate()); // -1
  /// print(Obj(-2.5).truncate()); // -2
  /// ```
  int? truncate() => value?.truncate();

  /// Returns the integer double value closest to `this`.
  ///
  /// Rounds away from zero when there is no closest integer:
  ///  `Obj(3.5).roundToDouble() == 4` and `Obj(-3.5).roundToDouble() == -4`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`,
  /// and `-0.0` is therefore considered closer to negative numbers than `0.0`.
  /// This means that for a value `d` in the range `-0.5 < d < 0.0`,
  /// the result is `-0.0`.
  /// ```dart
  /// print(Obj(3.0).roundToDouble()); // 3.0
  /// print(Obj(3.25).roundToDouble()); // 3.0
  /// print(Obj(3.5).roundToDouble()); // 4.0
  /// print(Obj(3.75).roundToDouble()); // 4.0
  /// print(Obj(-3.5).roundToDouble()); // -4.0
  /// ```
  double? roundToDouble() => value?.roundToDouble();

  /// Returns the greatest integer double value no greater than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `0.0 < d < 1.0` will return `0.0`.
  /// ```dart
  /// print(Obj(1.99999).floorToDouble()); // 1.0
  /// print(Obj(2.0).floorToDouble()); // 2.0
  /// print(Obj(2.99999).floorToDouble()); // 2.0
  /// print(Obj(-1.99999).floorToDouble()); // -2.0
  /// print(Obj(-2.0).floorToDouble()); // -2.0
  /// print(Obj(-2.00001).floorToDouble()); // -3.0
  /// ```
  double? floorToDouble() => value?.floorToDouble();

  /// Returns the least integer double value no smaller than `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`.
  /// ```dart
  /// print(Obj(1.99999).ceilToDouble()); // 2.0
  /// print(Obj(2.0).ceilToDouble()); // 2.0
  /// print(Obj(2.00001).ceilToDouble()); // 3.0
  /// print(Obj(-1.99999).ceilToDouble()); // -1.0
  /// print(Obj(-2.0).ceilToDouble()); // -2.0
  /// print(Obj(-2.00001).ceilToDouble()); // -2.0
  /// ```
  double? ceilToDouble() => value?.ceilToDouble();

  /// Returns the integer double value obtained by discarding any fractional
  /// digits from `this`.
  ///
  /// If this is already an integer valued double, including `-0.0`, or it is not
  /// a finite value, the value is returned unmodified.
  ///
  /// For the purpose of rounding, `-0.0` is considered to be below `0.0`.
  /// A number `d` in the range `-1.0 < d < 0.0` will return `-0.0`, and
  /// in the range `0.0 < d < 1.0` it will return 0.0.
  /// ```dart
  /// print(Obj(2.5).truncateToDouble()); // 2.0
  /// print(Obj(2.00001).truncateToDouble()); // 2.0
  /// print(Obj(1.99999).truncateToDouble()); // 1.0
  /// print(Obj(0.5).truncateToDouble()); // 0.0
  /// print(Obj(-0.5).truncateToDouble()); // -0.0
  /// print(Obj(-1.5).truncateToDouble()); // -1.0
  /// print(Obj(-2.5).truncateToDouble()); // -2.0
  /// ```
  double? truncateToDouble() => value?.truncateToDouble();
}
