part of '../framework.dart';

/// {@template reactter.rt_dependency}
/// Represents dependency managed by Reactter's dependency injection.
///
/// This class extends [DependencyRef] and provides an optional [id] parameter.
/// {@endtemplate}
class RtDependency<T> extends DependencyRef<T> {
  const RtDependency([String? id]) : super(id);
}
