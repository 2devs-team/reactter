part of '../internals.dart';

/// A generic class that represents the reference to a dependency in Reactter's context.
/// Provides an optional [id] parameter for identifying the dependency.
///
/// This class is used by the dependency injection and event manager to identify dependency
@internal
class DependencyRef<T extends Object?> {
  final String? id;

  Type get type => getType<T?>();

  const DependencyRef([this.id]);

  Type getType<TT extends T?>() => TT;

  @override
  int get hashCode => Object.hash(type, id);

  @override
  bool operator ==(Object other) {
    return other is DependencyRef<T?> && other.id == this.id;
  }
}
