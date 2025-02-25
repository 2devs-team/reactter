part of '../framework.dart';

/// {@template reactter.rt_dependency_ref}
/// Represents dependency managed by Reactter's dependency injection.
///
/// This class extends [DependencyRef] and provides an optional [id] parameter.
/// {@endtemplate}
class RtDependencyRef<T> extends DependencyRef<T> {
  const RtDependencyRef([String? id]) : super(id);
}
