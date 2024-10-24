part of '../internals.dart';

/// A generic class that represents the reference to a dependency in Reactter's context.
/// Provides an optional [id] parameter for identifying the dependency.
///
/// This class is used by the dependency injection and event manager to identify dependency
@internal
class DependencyRef<T extends Object?> {
  final String? id;

  Type get type => T;

  const DependencyRef([this.id]);

  int _getTypeHashCode<TT extends T?>() => TT.hashCode;

  @override
  int get hashCode => Object.hash(_getTypeHashCode<T?>(), id.hashCode);

  @override
  bool operator ==(Object other) {
    return other is DependencyRef<T?> && other.id == this.id;
  }
}
