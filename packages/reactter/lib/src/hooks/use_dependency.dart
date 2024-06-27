part of 'hooks.dart';

@Deprecated(
  'Use `UseDependency` instead. '
  'This feature was deprecated after v7.1.0.',
)
typedef UseInstance<T extends Object> = UseDependency<T>;

/// {@template use_dependency}
/// A [ReactterHook] that allows to manages a dependency of [T] with/without [id].
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
/// - **Reactter.get**:
///   {@macro get}
/// - **Reactter.create**:
///   {@macro create}
/// - **Reactter.builder**:
///   {@macro builder}
/// - **Reactter.singleton**:
///   {@macro builder}
///
/// or created by [ReactterProvider] of [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
///
/// [UseDependency] providers the following constructors:
///
/// - **[UseDependency.register]**:
///   {@macro register}
/// - **[UseDependency.lazyBuilder]**:
///   {@macro lazy_builder}
/// - **[UseDependency.lazyFactory]**:
///   {@macro lazy_factory}
/// - **[UseDependency.lazySingleton]**:
///   {@macro lazy_singleton}
/// - **[UseDependency.create]**:
///   {@macro create}
/// - **[UseDependency.builder]**:
///   {@macro builder}
/// - **[UseDependency.factory]**:
///   {@macro factory}
/// - **[UseDependency.singleton]**:
///   {@macro singleton}
/// - **[UseDependency.get]**:
///   {@macro get}
///
/// > **IMPORTANT**
/// > You should call [dispose] when it's no longer needed.
///
/// See also:
/// * [DependencyInjection], a dependency manager.
/// * [UseEffect], a side-effect manager.
/// {@endtemplate}
class UseDependency<T extends Object> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  bool _isDisposed = false;
  T? _instance;

  /// Returns the instance if found the dependency,
  /// or `null` if the dependency is not found it
  /// or has not been created yet.
  T? get instance {
    assert(!_isDisposed);

    if (_instance == null) {
      final instanceFound = Reactter.find<T>(id);

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

  /// {@macro use_dependency}
  UseDependency([this.id]) {
    _instance = Reactter.find<T>(id);
    _listen();
  }

  /// {@macro register}
  UseDependency.register(
    InstanceBuilder<T> builder, {
    DependencyMode mode = DependencyMode.builder,
    this.id,
  }) {
    Reactter.register(
      builder,
      id: id,
      mode: mode,
    );
    _listen();
  }

  /// {@macro lazy_builder}
  factory UseDependency.lazyBuilder(InstanceBuilder<T> builder, [String? id]) =>
      UseDependency.register(
        builder,
        mode: DependencyMode.builder,
        id: id,
      );

  /// {@macro lazy_factory}
  factory UseDependency.lazyFactory(InstanceBuilder<T> builder, [String? id]) =>
      UseDependency.register(
        builder,
        mode: DependencyMode.factory,
        id: id,
      );

  /// {@macro lazy_singleton}
  factory UseDependency.lazySingleton(InstanceBuilder<T> builder,
          [String? id]) =>
      UseDependency.register(
        builder,
        mode: DependencyMode.singleton,
        id: id,
      );

  /// {@macro create}
  UseDependency.create(
    InstanceBuilder<T> builder, {
    this.id,
    DependencyMode mode = DependencyMode.builder,
  }) {
    _instance = Reactter.create(
      builder,
      id: id,
      ref: this,
      mode: mode,
    );
    _listen();
  }

  /// {@macro builder}
  factory UseDependency.builder(InstanceBuilder<T> builder, [String? id]) =>
      UseDependency.create(
        builder,
        id: id,
        mode: DependencyMode.builder,
      );

  /// {@macro factory}
  factory UseDependency.factory(InstanceBuilder<T> builder, [String? id]) =>
      UseDependency.create(
        builder,
        id: id,
        mode: DependencyMode.factory,
      );

  /// {@macro singleton}
  factory UseDependency.singleton(InstanceBuilder<T> builder, [String? id]) =>
      UseDependency.create(
        builder,
        id: id,
        mode: DependencyMode.singleton,
      );

  /// {@macro get}
  UseDependency.get([this.id]) {
    _instance = Reactter.get(id, this);
    _listen();
  }

  /// Call when this hook is no longer needed.
  @override
  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;

    _unlisten();
    Reactter.delete<T>(id, this);

    update(() => _instance = null);

    super.dispose();
  }

  void _listen() {
    Reactter.on(ReactterDependency<T>(id), Lifecycle.created, _onInstance);
    Reactter.on(ReactterDependency<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.on(ReactterDependency<T>(id), Lifecycle.deleted, _onInstance);
  }

  void _unlisten() {
    Reactter.off(ReactterDependency<T>(id), Lifecycle.created, _onInstance);
    Reactter.off(ReactterDependency<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.off(ReactterDependency<T>(id), Lifecycle.deleted, _onInstance);
  }

  void _onInstance(inst, param) {
    if (_isDisposed) return;

    update(() => _instance = inst);
  }
}
