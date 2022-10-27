part of '../../core.dart';

extension ObjBoolExt on Obj<bool> {
  /// The logical conjunction ("and") of this and [other].
  ///
  /// Returns `true` if both this and [other] are `true`, and `false` otherwise.
  Obj<bool> operator &(Obj<bool> other) => (value && other.value).obj;

  /// The logical disjunction ("inclusive or") of this and [other].
  ///
  /// Returns `true` if either this or [other] is `true`, and `false` otherwise.
  Obj<bool> operator |(Obj<bool> other) => (value || other.value).obj;

  /// The logical exclusive disjunction ("exclusive or") of this and [other].
  ///
  /// Returns whether this and [other] are neither both `true` nor both `false`.
  Obj<bool> operator ^(Obj<bool> other) => (value ^ other.value).obj;
}
