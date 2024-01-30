part of 'core.dart';

/// A class that represents an instance register in Reactter.
///
/// An instance register is responsible for managing an instance of type [T].
/// It stores the mode of managing the instance and the refs where the instance was created.
/// The instance can be accessed through the [instance] getter.
///
@internal
class InstanceRegister<T> extends Instance<T?> {
  final InstanceBuilder<T?> builder;

  /// It's used to store the mode of managing an instance.
  final InstanceManageMode mode;

  /// Stores the refs where the instance was created.
  final refs = HashSet<int>();

  T? _instance;
  T? get instance => _instance;

  InstanceRegister(
    this.builder, {
    String? id,
    this.mode = InstanceManageMode.builder,
  }) : super(id);

  @override
  String toString() {
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '${super.toString()}$hashCode';
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is InstanceRegister<T>) {
      return other.id == this.id;
    }

    if (other is Instance<T?>) {
      return other.id == this.id;
    }

    return identical(other, this.instance);
  }
}
