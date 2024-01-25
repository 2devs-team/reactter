part of 'framework.dart';

/// A class that represents the interface for Reactter.
///
/// It is intended to be used as a mixin with other classes.
@internal
class ReactterInterface
    with StateManager, InstanceManager, EventManager, Logger {
  static final _reactterInterface = ReactterInterface._();
  factory ReactterInterface() => _reactterInterface;
  ReactterInterface._();
}

/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
final Reactter = ReactterInterface();
