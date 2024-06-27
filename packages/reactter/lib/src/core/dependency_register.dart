part of 'core.dart';

/// A class that represents a dependency register in Reactter.
///
/// a dependency register is responsible for managing a dependency of [T] type.
/// It stores the mode of managing the dependency and the refs where the dependency was created.
/// The instance of the dependency can be accessed through the [instance] getter.
///
/// > **FYI**: A dependency contains a builder function,
/// > and can contains an instance if it's created by [DependencyInjection]
///
@internal
class DependencyRegister<T> extends DependencyRef<T?> {
  final InstanceBuilder<T?> _builder;

  /// It's used to store the mode of managing an instance.
  final DependencyMode mode;

  /// Stores the refs where the instance was created.
  final refs = HashSet<int>();

  T? _instance;
  T? get instance => _instance;

  DependencyRegister(
    this._builder, {
    String? id,
    this.mode = DependencyMode.builder,
  }) : super(id);

  T? builder() {
    _instance = _builder();

    return _instance;
  }

  @override
  String toString() {
    final hashCode = instance != null ? "(${instance.hashCode})" : "";

    return '${super.toString()}$hashCode';
  }
}
