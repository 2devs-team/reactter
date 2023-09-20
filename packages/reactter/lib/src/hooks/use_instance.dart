part of '../hooks.dart';

/// A [ReactterHook] that allows to get the [T] instance with/without [id]
/// from dependency store when it's ready.
///
/// ```dart
/// final useAppController = UseInstance<AppController>();
/// final useOtherControllerWithId = UseInstance<OtherController>('uniqueId');
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
/// final useAppController = UseInstance<AppController>();
/// print(useAppController.instance);
/// ```
/// > **NOTE:**
/// > [instance] returns null, when the [T] instance is not found
/// or it hasn't created yet.
///
/// Use [UseEffect] hook to wait for the [instance] to be created.
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
/// > **IMPORTANT**
/// > You should call [dispose] when it's no longer needed.
///
/// See also:
///
/// * [ReactterInstanceManager], a instances manager.
/// * [UseEffect], a side-effect manager.

class UseInstance<T extends Object> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  bool _isDisposed = false;
  T? _instance;

  T? get instance {
    assert(!_isDisposed);
    return _instance;
  }

  final String? id;

  UseInstance([this.id]) {
    update(() => _instance = Reactter.get<T>(id));

    Reactter.on(ReactterInstance<T>(id), Lifecycle.initialized, _onInstance);
    Reactter.on(ReactterInstance<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.on(ReactterInstance<T>(id), Lifecycle.destroyed, _onInstance);
  }

  /// Call when this hook is no longer needed.
  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;

    Reactter.off(ReactterInstance<T>(id), Lifecycle.initialized, _onInstance);
    Reactter.off(ReactterInstance<T>(id), Lifecycle.willMount, _onInstance);
    Reactter.off(ReactterInstance<T>(id), Lifecycle.destroyed, _onInstance);

    update(() => _instance = null);

    super.dispose();
  }

  void _onInstance(inst, param) {
    if (_isDisposed) return;

    update(() => _instance = inst);
  }
}
