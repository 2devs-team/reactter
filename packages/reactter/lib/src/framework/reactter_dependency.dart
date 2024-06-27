part of 'framework.dart';

@Deprecated(
  'Use `ReactterDependency` instead. '
  'This feature was deprecated after v7.1.0.',
)
typedef ReactterInstance<T> = ReactterDependency<T>;

/// Represents dependency managed by Reactter's dependency injection.
///
/// This class extends [DependencyRef] and provides an optional [id] parameter.
class ReactterDependency<T> extends DependencyRef<T> {
  const ReactterDependency([String? id]) : super(id);
}
