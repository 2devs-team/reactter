part of 'framework.dart';

/// {@template reactter.rt_dependency}
/// Represents dependency managed by Reactter's dependency injection.
///
/// This class extends [DependencyRef] and provides an optional [id] parameter.
/// {@endtemplate}
class RtDependency<T> extends DependencyRef<T> {
  const RtDependency([String? id]) : super(id);
}

/// {@macro reactter.rt_dependency}
@Deprecated(
  'Use `RtDependency` instead.'
  'This feature was deprecated after v7.1.0.',
)
typedef ReactterInstance<T> = RtDependency<T>;

/// {@macro reactter.rt_dependency}
@Deprecated(
  'Use `RtDependency` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterDependency<T> = RtDependency<T>;
