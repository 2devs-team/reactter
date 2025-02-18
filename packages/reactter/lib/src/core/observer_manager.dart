part of '../internals.dart';

/// An abstract class representing an observer manager.
abstract class ObserverManager {
  /// Adds an observer to the manager.
  ///
  /// The [observer] parameter is the observer to be added.
  void addObserver(covariant IObserver observer) {
    if (observer is IStateObserver) {
      IStateObserver._observers.add(observer);
    }

    if (observer is IDependencyObserver) {
      IDependencyObserver._observers.add(observer);
    }
  }

  /// Removes an observer from the manager.
  ///
  /// The [observer] parameter is the observer to be removed.
  void removeObserver(IObserver observer) {
    if (observer is IStateObserver) {
      IStateObserver._observers.remove(observer);
    }

    if (observer is IDependencyObserver) {
      IDependencyObserver._observers.remove(observer);
    }
  }
}
