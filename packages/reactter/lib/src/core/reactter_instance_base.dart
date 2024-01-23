part of 'core.dart';

/// A generic class that represents an instance of a Reactter object and
/// provides methods for generating unique keys and retrieving the stored instance.
@internal
abstract class ReactterInstanceBase<T> {
  final String? id;

  const ReactterInstanceBase([this.id]);

  /// A getter that returns the instance of [T].
  T? get instance => Reactter._instanceRegisters.lookup(this)?.instance;

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";

    return '$type$id';
  }

  int _getTypeHashCode<TT extends T?>() => TT.hashCode;

  @override
  int get hashCode => _getTypeHashCode() ^ id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is ReactterInstanceBase<T?>) {
      return other.id == this.id;
    }

    // coverage:ignore-start
    return identical(other, this.instance);
    // coverage:ignore-end
  }
}
