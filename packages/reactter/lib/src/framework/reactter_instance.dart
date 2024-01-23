part of 'framework.dart';

/// Represents an instance of the Reactter framework.
///
/// This class extends [ReactterInstanceBase] and provides an optional [id] parameter.
class ReactterInstance<T> extends ReactterInstanceBase<T> {
  final String? id;

  const ReactterInstance([this.id]);
}
