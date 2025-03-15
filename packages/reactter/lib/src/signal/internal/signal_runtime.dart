part of '../../internals.dart';

class SignalRuntime {
  static StateSubscriber? _currentSub;
  static bool isRunning = false;

  static void link(StateDependency dep) {
    if (_currentSub == null) return;

    _currentSub?._deps.add(dep);

    if (_currentSub is Effect) {
      dep._effects.add(_currentSub as Effect);
    } else {
      dep._subs.add(_currentSub!);
    }
  }

  static void propagate(StateDependency dep) {
    dep.shouldNotify = true;

    if (isRunning) return;

    isRunning = true;
    Set<StateSubscriber> subsPending = dep._subs;
    Set<Effect> effectsPending = {};

    while (subsPending.isNotEmpty) {
      final subs = subsPending.toList(growable: false);
      subsPending = {};

      for (final sub in subs) {
        if (subsPending.contains(sub)) continue;

        sub.performDepedencyUpdate();

        if (sub is! StateDependency) continue;

        final dep = sub as StateDependency;

        if (!dep.shouldNotify) continue;

        subsPending.addAll(dep._subs);
        effectsPending.addAll(dep._effects);
        dep.shouldNotify = false;
      }
    }

    for (final effect in effectsPending) {
      effect.performDepedencyUpdate();
    }

    isRunning = false;
    dep.shouldNotify = false;
  }
}
