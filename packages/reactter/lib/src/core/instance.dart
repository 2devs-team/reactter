part of 'core.dart';

/// A generic class that represents an instance of a Reactter object and
/// provides methods for generating unique keys and retrieving the stored instance.
@internal
class Instance<T extends Object?> {
  final String? id;

  const Instance([this.id]);

  @override
  String toString() {
    final type = T.toString().replaceAll(RegExp(r'\?'), '');
    final id = this.id != null ? "[id='${this.id}']" : "";

    return '$type$id';
  }

  int _getTypeHashCode<TT extends T?>() => TT.hashCode;

  @override
  int get hashCode => Object.hash(_getTypeHashCode<T?>(), id.hashCode);

  @override
  bool operator ==(Object other) {
    return other is Instance<T?> && other.id == this.id;
  }
}
