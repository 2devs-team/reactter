part of '../hooks.dart';

/// A [ReactterHook]  that allows to get the [T] instance with/without [id]
/// from dependency store when it's ready.
///
/// ```dart
/// final useAppController = UseContext<AppController>();
/// final useOtherControllerWithId = UseContext<OtherController>('uniqueId');
/// ```
///
/// The [T] instance that you need to get, to must be created by [ReactterInstanceManager]:
///
/// ```dart
/// Reactter.create<AppController>(() => AppContex());
/// ```
///
/// or created by [ReactterProvider] of [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
///
/// Use [instance] getter to get the [T] instance:
///
/// ```dart
/// final useAppController = UseContext<AppController>();
/// print(useAppController.instance);
/// ```
/// > **NOTE:**
/// > [instance] returns null, when the [T] instance is not found
/// or it hasn't created yet.
///
/// Use [UseEffect] hook to wait for the [instance] to be created.
///
/// ```dart
/// final useAppController = UseContext<AppController>(context: this);
/// print(useAppController.instance); // return null
///
/// UseEffect(() {
///   print(useAppController.instance); // return instance of AppController
/// }, [useAppController]);
/// ```
///
/// > **IMPORTANT**
/// > You should call [dispose] when it's no longer needed.
///
/// See also:
///
/// * [ReactterInstanceManager], a instances manager.
/// * [UseEffect], a side-effect manager.
class UseContext<T extends Object> extends ReactterHook {
  final String? id;

  bool _isDisposed = false;

  T? _instance;
  T? get instance {
    assert(!_isDisposed);

    return _instance;
  }

  UseContext([this.id]) {
    _getInstance();

    Reactter.on(ReactterInstance<T>(id), Lifecycle.destroyed, _onInstance);

    if (instance != null) return;

    Reactter.on(ReactterInstance<T>(id), Lifecycle.initialized, _onInstance);
    Reactter.on(ReactterInstance<T>(id), Lifecycle.willMount, _onInstance);
  }

  @override
  void attachTo(Object instance) {
    super.attachTo(instance);
    Reactter.one(instance, Lifecycle.destroyed, _onParentDestroyed);
  }

  void detachTo(Object instance) {
    Reactter.off(instance, Lifecycle.destroyed, _onParentDestroyed);
    super.detachTo(instance);
  }

  /// Call when this hook is no longer needed.
  void dispose() {
    if (_isDisposed) return;

    Reactter.off(ReactterInstance<T>(id), Lifecycle.initialized, _onInstance);
    Reactter.off(ReactterInstance<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.off(ReactterInstance<T>(id), Lifecycle.destroyed, _onInstance);

    update(() {
      _instance = null;
    });

    _isDisposed = true;

    super.dispose();
  }

  void _getInstance() {
    update(() {
      _instance = Reactter.get<T>(id);
    });
  }

  void _onInstance(inst, param) {
    if (_isDisposed) return;

    update(() {
      _instance = inst;
    });
  }

  void _onParentDestroyed(_, __) => dispose();
}
