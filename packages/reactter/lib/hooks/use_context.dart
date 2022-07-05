part of '../hooks.dart';

/// A hook that helps to get the context by [T] with or without [id].
///
/// ```dart
/// final appContext = UseContext<AppContext>();
/// final appContextWithId = UseContext<AppContext>('uniqueId');
/// ```
///
/// The context that you need to get, to must be created by [ReactterFactory]:
///
/// ```dart
/// Reactter.factory.createInstance<AppContext>(() => AppContex());
/// ```
///
/// or created by [ReactterProvider] of [`flutter_reactter`](https://pub.dev/packages/flutter_reactter)
///
/// If the context is not already created cand
///
/// See also:
/// - [ReactterFactory], a instances manager
class UseContext<T extends ReactterContext> extends ReactterHook {
  final String? id;
  final ReactterContext? context;

  bool isDisposed = false;

  T? _instance;
  T? get instance {
    assert(!isDisposed);

    return _instance;
  }

  UseContext(this.id, [this.context]) : super(context) {
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

  dispose() {
    UseEvent<T>(id).off(LifeCycle.initialized, _onInstance);
    UseEvent<T>(id).off(LifeCycle.willMount, _onInstance);
    UseEvent<T>(id).off(LifeCycle.destroyed, _onInstance);

    _instance = null;
    isDisposed = true;
  }

  void _getInstance() {
    update(() {
      _instance = Reactter.factory.getInstance<T>(id: id);
    });
  }

  void _onInstance(inst, param) {
    update(() {
      _instance = inst;
    });
  }
}
