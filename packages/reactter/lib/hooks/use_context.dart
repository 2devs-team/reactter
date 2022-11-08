part of '../hooks.dart';

/// A [ReactterHook] that helps to get the context of [ReactterContext] by [T] with or without [id].
///
/// ```dart
/// final appContextHook = UseContext<AppContext>();
/// final appContextWithIdHook = UseContext<AppContext>('uniqueId');
/// ```
///
/// The context that you need to get, to must be created by [ReactterInstanceManager]:
///
/// ```dart
/// Reactter.create<AppContext>(() => AppContex());
/// ```
///
/// or created by [ReactterProvider] of [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
///
/// You can get instance, using [instance] getter:
///
/// ```dart
/// final appContextHook = UseContext<AppContext>();
/// print(appContextHook.instance);
/// ```
/// [instance] returns null, when the instance is not found
/// or it hasn't created yet.
///
/// To wait for the [instance] to be created,
/// you need to use the [UseEffect] hook.
///
/// ```dart
/// final appContextHook = UseContext<AppContext>(null, this);
/// print(appContextHook.instance); // return null
///
/// UseEffect(() {
///   print(appContextHook.instance); // return instance of AppContext
/// }, [appContextHook]);
/// ```
///
/// You should call [dispose] when it's no longer needed.
///
/// See also:
/// - [ReactterContext], the instance that it returns.
/// - [ReactterInstanceManager], a instances manager.
/// - [UseEffect], a side-effect manager.
class UseContext<T extends ReactterContext> extends ReactterHook {
  final String? id;
  final ReactterContext? context;

  bool _isDisposed = false;

  T? _instance;
  T? get instance {
    assert(!_isDisposed);

    return _instance;
  }

  UseContext({
    this.id,
    this.context,
  }) : super(context) {
    if (context != null) {
      Reactter.one(context, Lifecycle.destroyed, (_, __) => dispose);
    }

    _getInstance();

    Reactter.on(
      ReactterInstance<T>(id),
      Lifecycle.destroyed,
      _onInstance,
    );

    if (instance != null) return;

    Reactter.on(
      ReactterInstance<T>(id),
      Lifecycle.initialized,
      _onInstance,
    );
    Reactter.on(
      ReactterInstance<T>(id),
      Lifecycle.willMount,
      _onInstance,
    );
  }

  /// Call when this hook is no longer needed.
  void dispose() {
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
}
