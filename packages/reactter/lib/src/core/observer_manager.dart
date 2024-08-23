part of '../internals.dart';

/// An abstract class representing an observer manager.
abstract class ObserverManager {
  /// Adds an observer to the manager.
  ///
  /// The [observer] parameter is the observer to be added.
  /// Only [StateObserver] instances can be added.
  void addObserver(covariant IObserver observer) {
    if (observer is StateObserver) {
      StateObserver._observers.add(observer);
    }
  }

  /// Removes an observer from the manager.
  ///
  /// The [observer] parameter is the observer to be removed.
  /// Only [StateObserver] instances can be removed.
  void removeObserver(covariant IObserver observer) {
    if (observer is StateObserver) {
      StateObserver._observers.remove(observer);
    }
  }
}
