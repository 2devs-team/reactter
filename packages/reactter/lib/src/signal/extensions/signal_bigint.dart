// coverage:ignore-file
part of '../signal.dart';

extension SignalBigIntExt on Signal<BigInt> {
  /// Return the negative value of this integer.
  ///
  /// The result of negating an integer always has the opposite sign, except
  /// for zero, which is its own negation.
  BigInt operator -() => -value;

  /// Adds [other] to this big integer.
  ///
  /// The result is again a big integer.
  BigInt operator +(BigInt other) => value + other;

  /// Subtracts [other] from this big integer.
  ///
  /// The result is again a big integer.
  BigInt operator -(BigInt other) => value - other;

  /// Multiplies [other] by this big integer.
  ///
  /// The result is again a big integer.
  BigInt operator *(BigInt other) => value * other;

  /// Double division operator.
  ///
  /// Matching the similar operator on [int],
  /// this operation first performs [toDouble] on both this big integer
  /// and [other], then does [double.operator/] on those values and
  /// returns the result.
  ///
  /// **Note:** The initial [toDouble] conversion may lose precision.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(1)) / BigInt.from(2)); // 0.5
  /// print(Signal(BigInt.from(1.99999)) / BigInt.from(2)); // 0.5
  /// ```
  double operator /(BigInt other) => value / other;

  /// Truncating integer division operator.
  ///
  /// Performs a truncating integer division, where the remainder is discarded.
  ///
  /// The remainder can be computed using the [remainder] method.
  ///
  /// Examples:
  /// ```dart
  /// var seven = Signal(BigInt.from(7));
  /// var three = BigInt.from(3);
  /// seven ~/ three;    // => 2
  /// (-seven) ~/ three; // => -2
  /// seven ~/ -three;   // => -2
  /// seven.remainder(three);    // => 1
  /// (-seven).remainder(three); // => -1
  /// seven.remainder(-three);   // => 1
  /// ```
  BigInt operator ~/(BigInt other) => value ~/ other;

  /// Euclidean modulo operator.
  ///
  /// Returns the remainder of the Euclidean division. The Euclidean division of
  /// two integers `a` and `b` yields two integers `q` and `r` such that
  /// `a == b * q + r` and `0 <= r < b.abs()`.
  ///
  /// The sign of the returned value `r` is always positive.
  ///
  /// See [remainder] for the remainder of the truncating division.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(5)) % BigInt.from(3)); // 2
  /// print(Signal(BigInt.from(-5)) % BigInt.from(3)); // 1
  /// print(Signal(BigInt.from(5)) % BigInt.from(-3)); // 2
  /// print(Signal(BigInt.from(-5)) % BigInt.from(-3)); // 1
  /// ```
  BigInt operator %(BigInt other) => value % other;

  /// Shift the bits of this integer to the left by [shiftAmount].
  ///
  /// Shifting to the left makes the number larger, effectively multiplying
  /// the number by `pow(2, shiftIndex)`.
  ///
  /// There is no limit on the size of the result. It may be relevant to
  /// limit intermediate values by using the "and" operator with a suitable
  /// mask.
  ///
  /// It is an error if [shiftAmount] is negative.
  BigInt operator <<(int shiftAmount) => value << shiftAmount;

  /// Shift the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  ///`pow(2, shiftIndex)`.
  ///
  /// It is an error if [shiftAmount] is negative.
  BigInt operator >>(int shiftAmount) => value >> shiftAmount;

  /// Bit-wise and operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with only the bits set that are set in
  /// both `this` and [other]
  ///
  /// Of both operands are negative, the result is negative, otherwise
  /// the result is non-negative.
  BigInt operator &(BigInt other) => value & other;

  /// Bit-wise or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in either
  /// of `this` and [other]
  ///
  /// If both operands are non-negative, the result is non-negative,
  /// otherwise the result is negative.
  BigInt operator |(BigInt other) => value | other;

  /// Bit-wise exclusive-or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in one,
  /// but not both, of `this` and [other]
  ///
  /// If the operands have the same sign, the result is non-negative,
  /// otherwise the result is negative.
  BigInt operator ^(BigInt other) => value ^ other;

  /// The bit-wise negate operator.
  ///
  /// Treating `this` as a sufficiently large two's component integer,
  /// the result is a number with the opposite bits set.
  ///
  /// This maps any integer `x` to `-x - 1`.
  BigInt operator ~() => ~value;

  /// Whether this big integer is numerically smaller than [other].
  bool operator <(BigInt other) => value < other;

  /// Whether [other] is numerically greater than this big integer.
  bool operator <=(BigInt other) => value <= other;

  /// Whether this big integer is numerically greater than [other].
  bool operator >(BigInt other) => value > other;

  /// Whether [other] is numerically smaller than this big integer.
  bool operator >=(BigInt other) => value >= other;

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `x`, the result is the same as `x < 0 ? -x : x`.
  BigInt abs() => value.abs();

  /// Returns the remainder of the truncating division of `this` by [other].
  ///
  /// The result `r` of this operation satisfies:
  /// `this == (this ~/ other) * other + r`.
  /// As a consequence the remainder `r` has the same sign as the divider `this`.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(5)).remainder(BigInt.from(3))); // 2
  /// print(Signal(BigInt.from(-5)).remainder(BigInt.from(3))); // -2
  /// print(Signal(BigInt.from(5)).remainder(BigInt.from(-3))); // 2
  /// print(Signal(BigInt.from(-5)).remainder(BigInt.from(-3))); // -2
  /// ```
  BigInt remainder(BigInt other) => value.remainder(other);

  /// Compares this to `other`.
  ///
  /// Returns a negative number if `this` is less than `other`, zero if they are
  /// equal, and a positive number if `this` is greater than `other`.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(1)).compareTo(BigInt.from(2))); // => -1
  /// print(Signal(BigInt.from(2)).compareTo(BigInt.from(1))); // => 1
  /// print(Signal(BigInt.from(1)).compareTo(BigInt.from(1))); // => 0
  /// ```
  int compareTo(BigInt other) => value.compareTo(other);

  /// Returns the minimum number of bits required to store this big integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values. Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  ///
  /// ```dart
  /// x.bitLength == (-x-1).bitLength;
  ///
  /// Signal(BigInt.from(3)).bitLength == 2;   // 00000011
  /// Signal(BigInt.from(2)).bitLength == 2;   // 00000010
  /// Signal(BigInt.from(1)).bitLength == 1;   // 00000001
  /// Signal(BigInt.from(0)).bitLength == 0;   // 00000000
  /// Signal(BigInt.from(-1)).bitLength == 0;  // 11111111
  /// Signal(BigInt.from(-2)).bitLength == 1;  // 11111110
  /// Signal(BigInt.from(-3)).bitLength == 2;  // 11111101
  /// Signal(BigInt.from(-4)).bitLength == 2;  // 11111100
  /// ```
  int get bitLength => value.bitLength;

  /// Returns the sign of this big integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int get sign => value.sign;

  /// Whether this big integer is even.
  bool get isEven => value.isEven;

  /// Whether this big integer is odd.
  bool get isOdd => value.isOdd;

  /// Whether this number is negative.
  bool get isNegative => value.isNegative;

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [one] if the [exponent] equals 0.
  ///
  /// The [exponent] must otherwise be positive.
  ///
  /// The result is always equal to the mathematical result of this to the power
  /// [exponent], only limited by the available memory.
  ///
  /// Example:
  /// ```dart
  /// var value = Signal(BigInt.from(1000));
  /// print(value.pow(0)); // 1
  /// print(value.pow(1)); // 1000
  /// print(value.pow(2)); // 1000000
  /// print(value.pow(3)); // 1000000000
  /// print(value.pow(4)); // 1000000000000
  /// print(value.pow(5)); // 1000000000000000
  /// print(value.pow(6)); // 1000000000000000000
  /// print(value.pow(7)); // 1000000000000000000000
  /// print(value.pow(8)); // 1000000000000000000000000
  /// ```
  BigInt pow(int exponent) => value.pow(exponent);

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  BigInt modPow(BigInt exponent, BigInt modulus) =>
      value.modPow(exponent, modulus);

  /// Returns the modular multiplicative inverse of this big integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  // Returns 1/this % modulus, with modulus > 0.
  BigInt modInverse(BigInt modulus) => value.modInverse(modulus);

  /// Returns the greatest common divisor of this big integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(4)).gcd(BigInt.from(2))); // 2
  /// print(Signal(BigInt.from(8)).gcd(BigInt.from(4))); // 4
  /// print(Signal(BigInt.from(10)).gcd(BigInt.from(12))); // 2
  /// print(Signal(BigInt.from(10)).gcd(BigInt.from(10))); // 10
  /// print(Signal(BigInt.from(-2)).gcd(BigInt.from(-3))); // 1
  /// ```
  BigInt gcd(BigInt other) => value.gcd(other);

  /// Returns the least significant [width] bits of this big integer as a
  /// non-negative number (i.e. unsigned representation). The returned value has
  /// zeros in all bit positions higher than [width].
  ///
  /// ```dart
  /// Signal(BigInt.from(-1)).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  ///
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit quantity:
  ///
  /// ```dart
  /// q = (q + 1).toUnsigned(8);
  /// ```
  ///
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input. The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  ///
  /// ```dart
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  BigInt toUnsigned(int width) => value.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign. This is the same as truncating the value
  /// to fit in [width] bits using an signed 2-s complement representation. The
  /// returned value has the same bit value in all positions higher than [width].
  ///
  /// ```dart
  /// var big15 = Signal(BigInt.from(15));
  /// var big16 = Signal(BigInt.from(16));
  /// var big239 = Signal(BigInt.from(239));
  ///                                //     V--sign bit-V
  /// big16.toSigned(5) == -big16;   //  00010000 -> 11110000
  /// big239.toSigned(5) == big15;   //  11101111 -> 00001111
  ///                                //     ^           ^
  /// ```
  ///
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit signed quantity:
  ///
  /// ```dart
  /// q = (q + 1).toSigned(8);
  /// ```
  ///
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input. The minimum width needed to avoid truncation of `x`
  /// is `x.bitLength + 1`, i.e.
  ///
  /// ```dart
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  BigInt toSigned(int width) => value.toSigned(width);

  /// Whether this big integer can be represented as an `int` without losing
  /// precision.
  ///
  /// **Warning:** this function may give a different result on
  /// dart2js, dev compiler, and the VM, due to the differences in
  /// integer precision.
  ///
  /// Example:
  /// ```dart
  /// var bigNumber = BigInt.parse('100000000000000000000000');
  /// print(bigNumber.isValidInt); // false
  ///
  /// var value = BigInt.parse('0xFF'); // 255
  /// print(value.isValidInt); // true
  /// ```
  bool get isValidInt => value.isValidInt;

  /// Returns this [BigInt] as an [int].
  ///
  /// If the number does not fit, clamps to the max (or min)
  /// integer.
  ///
  /// **Warning:** the clamping behaves differently between the web and
  /// native platforms due to the differences in integer precision.
  ///
  /// Example:
  /// ```dart
  /// var bigNumber = BigInt.parse('100000000000000000000000');
  /// print(bigNumber.isValidInt); // false
  /// print(bigNumber.toInt()); // 9223372036854775807
  /// ```
  int toInt() => value.toInt();

  /// Returns this [BigInt] as a [double].
  ///
  /// If the number is not representable as a [double], an
  /// approximation is returned. For numerically large integers, the
  /// approximation may be infinite.
  ///
  /// Example:
  /// ```dart
  /// var bigNumber = BigInt.parse('100000000000000000000000');
  /// print(bigNumber.toDouble()); // 1e+23
  /// ```
  double toDouble() => value.toDouble();

  /// Converts [this] to a string representation in the given [radix].
  ///
  /// In the string representation, lower-case letters are used for digits above
  /// '9', with 'a' being 10 an 'z' being 35.
  ///
  /// The [radix] argument must be an integer in the range 2 to 36.
  ///
  /// Example:
  /// ```dart
  /// // Binary (base 2).
  /// print(Signal(BigInt.from(12)).toRadixString(2)); // 1100
  /// print(Signal(BigInt.from(31)).toRadixString(2)); // 11111
  /// print(Signal(BigInt.from(2021)).toRadixString(2)); // 11111100101
  /// print(Signal(BigInt.from(-)12).toRadixString(2)); // -1100
  /// // Octal (base 8).
  /// print(Signal(BigInt.from(12)).toRadixString(8)); // 14
  /// print(Signal(BigInt.from(31)).toRadixString(8)); // 37
  /// print(Signal(BigInt.from(2021)).toRadixString(8)); // 3745
  /// // Hexadecimal (base 16).
  /// print(Signal(BigInt.from(12)).toRadixString(16)); // c
  /// print(Signal(BigInt.from(31)).toRadixString(16)); // 1f
  /// print(Signal(BigInt.from(2021)).toRadixString(16)); // 7e5
  /// // Base 36.
  /// print(Signal(BigInt.from(35 * 36 + 1)).toRadixString(36)); // z1
  /// ```
  String toRadixString(int radix) => value.toRadixString(radix);
}

extension SignalBigIntNullExt on Signal<BigInt?> {
  /// Returns the absolute value of this integer.
  ///
  /// For any integer `x`, the result is the same as `x < 0 ? -x : x`.
  BigInt? abs() => value?.abs();

  /// Returns the remainder of the truncating division of `this` by [other].
  ///
  /// The result `r` of this operation satisfies:
  /// `this == (this ~/ other) * other + r`.
  /// As a consequence the remainder `r` has the same sign as the divider `this`.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(5)).remainder(BigInt.from(3))); // 2
  /// print(Signal(BigInt.from(-5)).remainder(BigInt.from(3))); // -2
  /// print(Signal(BigInt.from(5)).remainder(BigInt.from(-3))); // 2
  /// print(Signal(BigInt.from(-5)).remainder(BigInt.from(-3))); // -2
  /// ```
  BigInt? remainder(BigInt other) => value?.remainder(other);

  /// Compares this to `other`.
  ///
  /// Returns a negative number if `this` is less than `other`, zero if they are
  /// equal, and a positive number if `this` is greater than `other`.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(1)).compareTo(BigInt.from(2))); // => -1
  /// print(Signal(BigInt.from(2)).compareTo(BigInt.from(1))); // => 1
  /// print(Signal(BigInt.from(1)).compareTo(BigInt.from(1))); // => 0
  /// ```
  int? compareTo(BigInt other) => value?.compareTo(other);

  /// Returns the minimum number of bits required to store this big integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values. Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  ///
  /// ```dart
  /// x.bitLength == (-x-1).bitLength;
  ///
  /// Signal(BigInt.from(3)).bitLength == 2;   // 00000011
  /// Signal(BigInt.from(2)).bitLength == 2;   // 00000010
  /// Signal(BigInt.from(1)).bitLength == 1;   // 00000001
  /// Signal(BigInt.from(0)).bitLength == 0;   // 00000000
  /// Signal(BigInt.from(-1)).bitLength == 0;  // 11111111
  /// Signal(BigInt.from(-2)).bitLength == 1;  // 11111110
  /// Signal(BigInt.from(-3)).bitLength == 2;  // 11111101
  /// Signal(BigInt.from(-4)).bitLength == 2;  // 11111100
  /// ```
  int? get bitLength => value?.bitLength;

  /// Returns the sign of this big integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int? get sign => value?.sign;

  /// Whether this big integer is even.
  bool? get isEven => value?.isEven;

  /// Whether this big integer is odd.
  bool? get isOdd => value?.isOdd;

  /// Whether this number is negative.
  bool? get isNegative => value?.isNegative;

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [one] if the [exponent] equals 0.
  ///
  /// The [exponent] must otherwise be positive.
  ///
  /// The result is always equal to the mathematical result of this to the power
  /// [exponent], only limited by the available memory.
  ///
  /// Example:
  /// ```dart
  /// var value = Signal(BigInt.from(1000));
  /// print(value.pow(0)); // 1
  /// print(value.pow(1)); // 1000
  /// print(value.pow(2)); // 1000000
  /// print(value.pow(3)); // 1000000000
  /// print(value.pow(4)); // 1000000000000
  /// print(value.pow(5)); // 1000000000000000
  /// print(value.pow(6)); // 1000000000000000000
  /// print(value.pow(7)); // 1000000000000000000000
  /// print(value.pow(8)); // 1000000000000000000000000
  /// ```
  BigInt? pow(int exponent) => value?.pow(exponent);

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  BigInt? modPow(BigInt exponent, BigInt modulus) =>
      value?.modPow(exponent, modulus);

  /// Returns the modular multiplicative inverse of this big integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  // Returns 1/this % modulus, with modulus > 0.
  BigInt? modInverse(BigInt modulus) => value?.modInverse(modulus);

  /// Returns the greatest common divisor of this big integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  ///
  /// Example:
  /// ```dart
  /// print(Signal(BigInt.from(4)).gcd(BigInt.from(2))); // 2
  /// print(Signal(BigInt.from(8)).gcd(BigInt.from(4))); // 4
  /// print(Signal(BigInt.from(10)).gcd(BigInt.from(12))); // 2
  /// print(Signal(BigInt.from(10)).gcd(BigInt.from(10))); // 10
  /// print(Signal(BigInt.from(-2)).gcd(BigInt.from(-3))); // 1
  /// ```
  BigInt? gcd(BigInt other) => value?.gcd(other);

  /// Returns the least significant [width] bits of this big integer as a
  /// non-negative number (i.e. unsigned representation). The returned value has
  /// zeros in all bit positions higher than [width].
  ///
  /// ```dart
  /// Signal(BigInt.from(-1)).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  ///
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit quantity:
  ///
  /// ```dart
  /// q = (q + 1).toUnsigned(8);
  /// ```
  ///
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input. The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  ///
  /// ```dart
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  BigInt? toUnsigned(int width) => value?.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign. This is the same as truncating the value
  /// to fit in [width] bits using an signed 2-s complement representation. The
  /// returned value has the same bit value in all positions higher than [width].
  ///
  /// ```dart
  /// var big15 = Signal(BigInt.from(15));
  /// var big16 = Signal(BigInt.from(16));
  /// var big239 = Signal(BigInt.from(239));
  ///                                //     V--sign bit-V
  /// big16.toSigned(5) == -big16;   //  00010000 -> 11110000
  /// big239.toSigned(5) == big15;   //  11101111 -> 00001111
  ///                                //     ^           ^
  /// ```
  ///
  /// This operation can be used to simulate arithmetic from low level languages.
  /// For example, to increment an 8 bit signed quantity:
  ///
  /// ```dart
  /// q = (q + 1).toSigned(8);
  /// ```
  ///
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input. The minimum width needed to avoid truncation of `x`
  /// is `x.bitLength + 1`, i.e.
  ///
  /// ```dart
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  BigInt? toSigned(int width) => value?.toSigned(width);

  /// Whether this big integer can be represented as an `int` without losing
  /// precision.
  ///
  /// **Warning:** this function may give a different result on
  /// dart2js, dev compiler, and the VM, due to the differences in
  /// integer precision.
  ///
  /// Example:
  /// ```dart
  /// var bigNumber = BigInt.parse('100000000000000000000000');
  /// print(bigNumber.isValidInt); // false
  ///
  /// var value = BigInt.parse('0xFF'); // 255
  /// print(value.isValidInt); // true
  /// ```
  bool? get isValidInt => value?.isValidInt;

  /// Returns this [BigInt] as an [int].
  ///
  /// If the number does not fit, clamps to the max (or min)
  /// integer.
  ///
  /// **Warning:** the clamping behaves differently between the web and
  /// native platforms due to the differences in integer precision.
  ///
  /// Example:
  /// ```dart
  /// var bigNumber = BigInt.parse('100000000000000000000000');
  /// print(bigNumber.isValidInt); // false
  /// print(bigNumber.toInt()); // 9223372036854775807
  /// ```
  int? toInt() => value?.toInt();

  /// Returns this [BigInt] as a [double].
  ///
  /// If the number is not representable as a [double], an
  /// approximation is returned. For numerically large integers, the
  /// approximation may be infinite.
  ///
  /// Example:
  /// ```dart
  /// var bigNumber = BigInt.parse('100000000000000000000000');
  /// print(bigNumber.toDouble()); // 1e+23
  /// ```
  double? toDouble() => value?.toDouble();

  /// Converts [this] to a string representation in the given [radix].
  ///
  /// In the string representation, lower-case letters are used for digits above
  /// '9', with 'a' being 10 an 'z' being 35.
  ///
  /// The [radix] argument must be an integer in the range 2 to 36.
  ///
  /// Example:
  /// ```dart
  /// // Binary (base 2).
  /// print(Signal(BigInt.from(12)).toRadixString(2)); // 1100
  /// print(Signal(BigInt.from(31)).toRadixString(2)); // 11111
  /// print(Signal(BigInt.from(2021)).toRadixString(2)); // 11111100101
  /// print(Signal(BigInt.from(-12)).toRadixString(2)); // -1100
  /// // Octal (base 8).
  /// print(Signal(BigInt.from(12)).toRadixString(8)); // 14
  /// print(Signal(BigInt.from(31)).toRadixString(8)); // 37
  /// print(Signal(BigInt.from(2021)).toRadixString(8)); // 3745
  /// // Hexadecimal (base 16).
  /// print(Signal(BigInt.from(12)).toRadixString(16)); // c
  /// print(Signal(BigInt.from(31)).toRadixString(16)); // 1f
  /// print(Signal(BigInt.from(2021)).toRadixString(16)); // 7e5
  /// // Base 36.
  /// print(Signal(BigInt.from(35 * 36 + 1)).toRadixString(36)); // z1
  /// ```
  String? toRadixString(int radix) => value?.toRadixString(radix);
}
