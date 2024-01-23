part of 'framework.dart';

/// A class that represents the interface for Reactter.
///
/// It is intended to be used as a mixin with other classes.
@internal
class ReactterInterface with InstanceManager, EventManager, Logger {
  static final _reactterInterface = ReactterInterface._();
  factory ReactterInterface() => _reactterInterface;

  /// Loads a [ReactterState] lazily and attaches it to a specific instance.
  ///
  /// The [stateFn] parameter is a function that returns an instance of [ReactterState].
  /// The [instance] parameter is the object to which the state will be attached.
  ///
  /// Returns the loaded [ReactterState].
  T lazyState<T extends ReactterState>(T stateFn(), Object instance) {
    final zone = ReactterZone();
    try {
      return stateFn();
    } finally {
      zone.attachInstance(instance);
    }
  }

  ReactterInterface._();
}

/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
final Reactter = ReactterInterface();
