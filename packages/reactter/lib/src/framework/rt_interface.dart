part of '../internals.dart';

///{@template reactter.rt_interface}
/// A class that represents the interface for Rt.
///
/// It is intended to be used as a mixin with other classes.
/// {@endtemplate}
class RtInterface
    with
        StateManagement<RtState>,
        DependencyInjection,
        EventHandler,
        ObserverManager {
  @override
  @internal
  StateManagement<RtState> get stateManagement => this;
  @override
  @internal
  DependencyInjection get dependencyInjection => this;
  @override
  @internal
  EventHandler get eventHandler => this;

  @override
  void addObserver(covariant IObserver observer) {
    if (observer is RtStateObserver) {
      RtStateObserver._observers.add(observer);
    }

    if (observer is RtDependencyObserver) {
      RtDependencyObserver._observers.add(observer);
    }
  }

  @override
  void removeObserver(covariant IObserver observer) {
    if (observer is RtStateObserver) {
      RtStateObserver._observers.remove(observer);
    }

    if (observer is RtDependencyObserver) {
      RtDependencyObserver._observers.remove(observer);
    }
  }
}
