part of 'framework.dart';

/// Represents an instance of the Reactter framework.
///
/// This class extends [Instance] and provides an optional [id] parameter.
class ReactterInstance<T> extends Instance<T> {
  final String? id;

  const ReactterInstance([this.id]);
}
