part of '../hooks.dart';

/// A hook that helps to get the context of [ReactterContext] by [T] with or without [id].
///
/// ```dart
/// final appContext = UseContext<AppContext>();
/// final appContextWithId = UseContext<AppContext>('uniqueId');
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
/// final appContext = UseContext<AppContext>();
/// print(appContext.instance);
/// ```
/// [instance] returns null, when the instance is not found
/// or it hasn't created yet.
///
/// To wait for the [instance] to be created,
/// you need to use the [UseEffect] hook.
///
/// ```dart
/// final appContext = UseContext<AppContext>(null, this);
/// print(appContext.instance); // return null
///
/// UseEffect(() {
///   print(appContext.instance); // return instance of AppContext
/// }, [appContext]);
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

  UseContext([this.id, this.context]) : super(context) {
    if (context != null) {
      UseEvent.withInstance(context)
          .one(LifeCycle.destroyed, (_, __) => dispose);
    }

    _getInstance();

    UseEvent<T>(id).on(LifeCycle.destroyed, _onInstance);

    if (instance != null) return;

    UseEvent<T>(id).on(LifeCycle.initialized, _onInstance);
    UseEvent<T>(id).on(LifeCycle.willMount, _onInstance);
  }

  /// Call when this hook is no longer needed.
  dispose() {
    UseEvent<T>(id).off(LifeCycle.initialized, _onInstance);
    UseEvent<T>(id).off(LifeCycle.willMount, _onInstance);
    UseEvent<T>(id).off(LifeCycle.destroyed, _onInstance);

    _instance = null;
    _isDisposed = true;
  }

  void _getInstance() {
    update(() {
      _instance = Reactter.get<T>(id);
    });
  }

  void _onInstance(inst, param) {
    update(() {
      _instance = inst;
    });
  }
}
