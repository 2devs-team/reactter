part of 'framework.dart';

/// Represents an dependency of the Reactter framework.
///
/// This class extends [DependencyRef] and provides an optional [id] parameter.
class ReactterDependency<T> extends DependencyRef<T> {
  const ReactterDependency([String? id]) : super(id);
}
