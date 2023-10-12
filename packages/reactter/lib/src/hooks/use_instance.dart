part of '../hooks.dart';

/// A [ReactterHook] that allows to manages an instance of [T] with/without [id].
///
/// ```dart
/// final useAppController = UseInstance<AppController>();
/// final useOtherControllerWithId = UseInstance<OtherController>('uniqueId');
/// ```
///
/// Use [instance] getter to get the [T] instance:
///
/// ```dart
/// final useAppController = UseInstance<AppController>();
/// print(useAppController.instance);
/// ```
///
/// The [instance] getter returns `null`, if the [T] instance is not found
/// or it hasn't created yet.
/// You can wait for the [instance] to be created, using [UseEffect]:
///
/// ```dart
/// final useAppController = UseInstance<AppController>();
/// print(useAppController.instance); // return null
///
/// UseEffect(() {
///   print(useAppController.instance); // return instance of AppController
/// }, [useAppController]);
/// ```
///
/// The instance must be created by [ReactterInstanceManager] using the following methods:
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
/// [UseInstance] providers the following constructors:
///
/// - **[UseInstance.register]**:
///   {@macro register}
/// - **[UseInstance.lazyBuilder]**:
///   {@macro lazy_builder}
/// - **[UseInstance.lazyFactory]**:
///   {@macro lazy_factory}
/// - **[UseInstance.lazySingleton]**:
///   {@macro lazy_singleton}
/// - **[UseInstance.create]**:
///   {@macro create}
/// - **[UseInstance.builder]**:
///   {@macro builder}
/// - **[UseInstance.factory]**:
///   {@macro factory}
/// - **[UseInstance.singleton]**:
///   {@macro singleton}
/// - **[UseInstance.get]**:
///   {@macro get}
///
/// > **IMPORTANT**
/// > You should call [dispose] when it's no longer needed.
///
/// See also:
/// * [ReactterInstanceManager], a instances manager.
/// * [UseEffect], a side-effect manager.

class UseInstance<T extends Object> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  bool _isDisposed = false;
  T? _instance;

  /// Returns the instance if found it, or `null` if the instance is not found it
  /// or has not been created yet.
  T? get instance {
    assert(!_isDisposed);

    if (_instance == null) {
      final instanceFound = Reactter.find<T>(id);

      if (instanceFound != null) {
        update(() => _instance = instanceFound);
      }
    }

    return _instance;
  }

  /// It's used to identify the instance of [T] type.
  final String? id;

  UseInstance([this.id]) {
    _instance = Reactter.find<T>(id);
    _listen();
  }

  /// {@macro register}
  UseInstance.register(
    InstanceBuilder<T> builder, {
    InstanceType type = InstanceType.builder,
    this.id,
  }) {
    Reactter.register(
      builder,
      id: id,
      type: type,
    );
    _listen();
  }

  /// {@macro lazy_builder}
  factory UseInstance.lazyBuilder(InstanceBuilder<T> builder, [String? id]) =>
      UseInstance.register(
        builder,
        type: InstanceType.builder,
        id: id,
      );

  /// {@macro lazy_factory}
  factory UseInstance.lazyFactory(InstanceBuilder<T> builder, [String? id]) =>
      UseInstance.register(
        builder,
        type: InstanceType.factory,
        id: id,
      );

  /// {@macro lazy_singleton}
  factory UseInstance.lazySingleton(InstanceBuilder<T> builder, [String? id]) =>
      UseInstance.register(
        builder,
        type: InstanceType.singleton,
        id: id,
      );

  /// {@macro create}
  UseInstance.create(
    InstanceBuilder<T> builder, {
    this.id,
    InstanceType type = InstanceType.builder,
  }) {
    _instance = Reactter.create(
      builder,
      id: id,
      ref: this,
      type: type,
    );
    _listen();
  }

  /// {@macro builder}
  factory UseInstance.builder(InstanceBuilder<T> builder, [String? id]) =>
      UseInstance.create(
        builder,
        id: id,
        type: InstanceType.builder,
      );

  /// {@macro factory}
  factory UseInstance.factory(InstanceBuilder<T> builder, [String? id]) =>
      UseInstance.create(
        builder,
        id: id,
        type: InstanceType.factory,
      );

  /// {@macro singleton}
  factory UseInstance.singleton(InstanceBuilder<T> builder, [String? id]) =>
      UseInstance.create(
        builder,
        id: id,
        type: InstanceType.singleton,
      );

  /// {@macro get}
  UseInstance.get([this.id]) {
    _instance = Reactter.get(id, this);
    _listen();
  }

  /// Call when this hook is no longer needed.
  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;

    _unlisten();
    Reactter.delete<T>(id, this);

    update(() => _instance = null);

    super.dispose();
  }

  void _listen() {
    Reactter.on(ReactterInstance<T>(id), Lifecycle.initialized, _onInstance);
    Reactter.on(ReactterInstance<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.on(ReactterInstance<T>(id), Lifecycle.destroyed, _onInstance);
  }

  void _unlisten() {
    Reactter.off(ReactterInstance<T>(id), Lifecycle.initialized, _onInstance);
    Reactter.off(ReactterInstance<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.off(ReactterInstance<T>(id), Lifecycle.destroyed, _onInstance);
  }

  void _onInstance(inst, param) {
    if (_isDisposed) return;

    update(() => _instance = inst);
  }
}
