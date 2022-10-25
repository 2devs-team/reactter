part of '../core.dart';

enum Lifecycle {
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
/// Exposes two methods [_onHookWillUpdate] and [_onHookDidUpdate]
/// to subscribe and notify when any hooks has changed.
///
/// See also:
/// - [ReactterHook], a abstract hook that [ReactterHookManager] listen it.
abstract class ReactterHookManager {
  bool _isUpdating = false;

  /// Stores all the hooks given.
  final Set<ReactterHook> _hooks = {};

  /// Suscribes to all [hooks] given.
  @mustCallSuper
  void listenHooks(List<ReactterHook> hooks) {
    for (final hook in hooks) {
      hook._attachIt(this);
      _hooks.add(hook);
    }
  }

  // /// Executes [fnUpdate], and notify the listeners about to update.
  // void update([Function? callback]) {
  //   super.update(() => callback?.call());
  // }

  void _listenHooks() {
    for (final hook in _hooks) {
      Reactter.on(hook, Lifecycle.willUpdate, _onHookWillUpdate);
      Reactter.on(hook, Lifecycle.didUpdate, _onHookDidUpdate);
    }
  }

  void _unlistenHooks() {
    for (final hook in _hooks) {
      Reactter.off(hook, Lifecycle.willUpdate, _onHookWillUpdate);
      Reactter.off(hook, Lifecycle.didUpdate, _onHookDidUpdate);
    }
  }

  void _onHookWillUpdate(_, hook) {
    if (_isUpdating) return;

    Reactter.emit(this, Lifecycle.willUpdate, hook);
  }

  void _onHookDidUpdate(_, hook) {
    if (_isUpdating) return;

    Reactter.emit(this, Lifecycle.didUpdate, hook);
  }
}
