part of '../core.dart';

enum LifeCycle {
  /// Event when the instance has registered by [ReactterInstanceManager].
  registered,

  /// Event when the instance has unregistered by [ReactterInstanceManager].
  unregistered,

  /// Event when the instance has inicialized by [ReactterInstanceManager].
  initialized,

  /// Event when the instance will be mount in the widget tree (only it use with flutter_reactter).
  willMount,

  /// Event when the instance did be mount in the widget tree (only it use with flutter_reactter).
  didMount,

  /// Event when any instance's hooks will be update. Event param is a [ReactterHook].
  willUpdate,

  /// Event when any instance's hooks did be update. Event param is a [ReactterHook].
  didUpdate,

  /// Event when the instance will be unmount in the widget tree (only it use with flutter_reactter).
  willUnmount,

  /// Event when the instance did be destroyed by [ReactterInstanceManager].
  destroyed,
}

/// A hook manager.
///
/// Use [listenHooks] to watch hooks([ReactterHook])
/// and notify when it has changed.
///
/// Exposes two methods [onWillUpdate] and [onDidUpdate]
/// to subscribe and notify when any hooks has changed.
///
/// See also:
/// - [ReactterHook], a abstract hook that [ReactterHookManager] listen it.
abstract class ReactterHookManager {
  late final _event = UseEvent.withInstance(this);

  /// Stores all the hooks given.
  final Set<ReactterHook> _hooks = {};

  /// Suscribes to all [hooks] given.
  void listenHooks(List<ReactterHook> hooks) {
    for (final hook in hooks) {
      if (_hooks.contains(hook)) {
        return;
      }

      _hooks.add(hook);

      void onWillUpdate(_, hook) => _event.emit(LifeCycle.willUpdate, hook);

      void onDidUpdate(_, hook) => _event.emit(LifeCycle.didUpdate, hook);

      UseEvent.withInstance(hook)
        ..on(LifeCycle.willUpdate, onWillUpdate)
        ..on(LifeCycle.didUpdate, onDidUpdate);

      _event.one(LifeCycle.destroyed, (_, __) {
        UseEvent.withInstance(hook)
          ..off(LifeCycle.willUpdate, onWillUpdate)
          ..off(LifeCycle.didUpdate, onDidUpdate);
      });
    }
  }
}
