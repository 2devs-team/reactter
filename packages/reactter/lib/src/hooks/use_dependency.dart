part of 'hooks.dart';

/// {@template reactter.use_dependency}
/// A [RtHook] that allows to manages a dependency of [T] with/without [id].
///
/// ```dart
/// final useAppController = UseDependency<AppController>();
/// final useOtherControllerWithId = UseDependency<OtherController>('uniqueId');
/// ```
///
/// Use [instance] getter to get the [T] instance:
///
/// ```dart
/// final useAppController = UseDependency<AppController>();
/// print(useAppController.instance);
/// ```
///
/// The [instance] getter returns `null`, if the [T] dependency is not found
/// or it hasn't created yet.
/// You can wait for the [instance] to be created, using [UseEffect]:
///
/// ```dart
/// final useAppController = UseDependency<AppController>();
/// print(useAppController.instance); // return null
///
/// UseEffect(() {
///   print(useAppController.instance); // return instance of AppController
/// }, [useAppController]);
/// ```
///
/// The instance must be created by [DependencyInjection] using the following methods:
///
/// - **Rt.get**:
///   {@macro reactter.get}
/// - **Rt.create**:
///   {@macro reactter.create}
/// - **Rt.builder**:
///   {@macro reactter.builder}
/// - **Rt.singleton**:
///   {@macro reactter.builder}
///
/// or created by [RtProvider] of [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
///
/// [UseDependency] providers the following constructors:
///
/// - **[UseDependency.register]**:
///   {@macro reactter.register}
/// - **[UseDependency.lazyBuilder]**:
///   {@macro reactter.lazy_builder}
/// - **[UseDependency.lazyFactory]**:
///   {@macro lazy_factory}
/// - **[UseDependency.lazySingleton]**:
///   {@macro reactter.lazy_singleton}
/// - **[UseDependency.create]**:
///   {@macro reactter.create}
/// - **[UseDependency.builder]**:
///   {@macro reactter.builder}
/// - **[UseDependency.factory]**:
///   {@macro reactter.factory}
/// - **[UseDependency.singleton]**:
///   {@macro reactter.singleton}
/// - **[UseDependency.get]**:
///   {@macro reactter.get}
///
/// > **IMPORTANT**
/// > You should call [dispose] when it's no longer needed.
///
/// See also:
/// * [DependencyInjection], a dependency manager.
/// * [UseEffect], a side-effect manager.
/// {@endtemplate}
class UseDependency<T extends Object> extends RtHook {
  @protected
  @override
  final $ = RtHook.$register;

  bool _isDisposed = false;
  T? _instance;

  /// Returns the instance if found the dependency,
  /// or `null` if the dependency is not found it
  /// or has not been created yet.
  T? get instance {
    assert(!_isDisposed, 'Cannot use a disposed hook.');

    if (_instance == null) {
      final instanceFound = Rt.find<T>(id);

      // coverage:ignore-start
      /// this condition shouldn't be `true`
      /// because the instance already captured by the event listeners,
      /// but it is in case of any bugs.
      if (instanceFound != null) {
        update(() => _instance = instanceFound);
      }
      // coverage:ignore-end
    }

    return _instance;
  }

  /// It's used to identify the instance of [T] dependency.
  final String? id;

  final String? _debugLabel;
  @override
  String? get debugLabel => _debugLabel ?? super.debugLabel;
  @override
  Map<String, dynamic> get debugInfo => {
        'instance': instance,
        'id': id,
      };

  /// {@macro reactter.use_dependency}
  UseDependency({
    this.id,
    String? debugLabel,
  }) : _debugLabel = debugLabel {
    _instance = Rt.find<T>(id);
    _listen();
  }

  /// {@macro reactter.register}
  UseDependency.register(
    InstanceBuilder<T> builder, {
    DependencyMode mode = DependencyMode.builder,
    this.id,
    String? debugLabel,
  }) : _debugLabel = debugLabel {
    Rt.register(
      builder,
      id: id,
      mode: mode,
    );
    _listen();
  }

  /// {@macro reactter.lazy_builder}
  factory UseDependency.lazyBuilder(
    InstanceBuilder<T> builder, {
    String? id,
    String? debugLabel,
  }) {
    return UseDependency.register(
      builder,
      mode: DependencyMode.builder,
      id: id,
      debugLabel: debugLabel,
    );
  }

  /// {@macro reactter.lazy_factory}
  factory UseDependency.lazyFactory(
    InstanceBuilder<T> builder, {
    String? id,
    String? debugLabel,
  }) {
    return UseDependency.register(
      builder,
      mode: DependencyMode.factory,
      id: id,
      debugLabel: debugLabel,
    );
  }

  /// {@macro reactter.lazy_singleton}
  factory UseDependency.lazySingleton(
    InstanceBuilder<T> builder, {
    String? id,
    String? debugLabel,
  }) {
    return UseDependency.register(
      builder,
      mode: DependencyMode.singleton,
      id: id,
      debugLabel: debugLabel,
    );
  }

  /// {@macro reactter.create}
  UseDependency.create(
    InstanceBuilder<T> builder, {
    this.id,
    DependencyMode mode = DependencyMode.builder,
    String? debugLabel,
  }) : _debugLabel = debugLabel {
    _instance = Rt.create(
      builder,
      id: id,
      ref: this,
      mode: mode,
    );
    _listen();
  }

  /// {@macro reactter.builder}
  factory UseDependency.builder(
    InstanceBuilder<T> builder, {
    String? id,
    String? debugLabel,
  }) {
    return UseDependency.create(
      builder,
      id: id,
      mode: DependencyMode.builder,
      debugLabel: debugLabel,
    );
  }

  /// {@macro reactter.factory}
  factory UseDependency.factory(
    InstanceBuilder<T> builder, {
    String? id,
    String? debugLabel,
  }) {
    return UseDependency.create(
      builder,
      id: id,
      mode: DependencyMode.factory,
      debugLabel: debugLabel,
    );
  }

  /// {@macro reactter.singleton}
  factory UseDependency.singleton(
    InstanceBuilder<T> builder, {
    String? id,
    String? debugLabel,
  }) {
    return UseDependency.create(
      builder,
      id: id,
      mode: DependencyMode.singleton,
      debugLabel: debugLabel,
    );
  }

  /// {@macro reactter.get}
  UseDependency.get({
    this.id,
    String? debugLabel,
  }) : _debugLabel = debugLabel {
    _instance = Rt.get(id, this);
    _listen();
  }

  /// Call when this hook is no longer needed.
  @override
  void dispose() {
    if (_isDisposed) return;

    _unlisten();
    Rt.delete<T>(id, this);

    update(() {
      _instance = null;
      super.dispose();
    });

    _isDisposed = true;
  }

  void _listen() {
    Rt.on(RtDependency<T>(id), Lifecycle.created, _onInstance);
    Rt.on(RtDependency<T>(id), Lifecycle.willMount, _onInstance);
    Rt.on(RtDependency<T>(id), Lifecycle.deleted, _onInstance);
  }

  void _unlisten() {
    Rt.off(RtDependency<T>(id), Lifecycle.created, _onInstance);
    Rt.off(RtDependency<T>(id), Lifecycle.willMount, _onInstance);
    Rt.off(RtDependency<T>(id), Lifecycle.deleted, _onInstance);
  }

  void _onInstance(inst, param) {
    if (_isDisposed) return;

    update(() => _instance = inst);
  }
}
