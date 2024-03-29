part of 'framework.dart';

/// Represents an instance of the Reactter framework.
///
/// This class extends [InstanceRef] and provides an optional [id] parameter.
class ReactterInstance<T> extends InstanceRef<T> {
  const ReactterInstance([String? id]) : super(id);
}
