part of 'core.dart';

/// A generic class that represents the reference to an dependency in Reactter's context.
/// Provides an optional [id] parameter for identifying the dependency.
///
/// This class is used by the dependency injection and event manager to identify dependency
@internal
class DependencyRef<T extends Object?> {
  final String? id;

  const DependencyRef([this.id]);

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
    return other is DependencyRef<T?> && other.id == this.id;
  }
}
