part of '../internals.dart';

/// An abstract class representing an observer manager.
abstract class ObserverManager {
  /// Adds an observer to the manager.
  ///
  /// The [observer] parameter is the observer to be added.
  void addObserver(covariant IObserver observer);

  /// Removes an observer from the manager.
  ///
  /// The [observer] parameter is the observer to be removed.
  void removeObserver(covariant IObserver observer);
}
