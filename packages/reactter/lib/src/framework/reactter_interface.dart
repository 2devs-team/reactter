part of 'framework.dart';

void defaultLogWriterCallback(
  String value, {
  Object? error,
  LogLevel? level = LogLevel.info,
}) {
  if (Reactter.isLogEnable || error != null) {
    dev.log(value, name: 'REACTTER', error: error);
  }
}

/// A class that represents the interface for Reactter.
///
/// It is intended to be used as a mixin with other classes.
@internal
class ReactterInterface
    with StateManager<ReactterState>, InstanceManager, EventManager, Logger {
  static final _reactterInterface = ReactterInterface._();
  factory ReactterInterface() => _reactterInterface;
  ReactterInterface._();

  @internal
  InstanceManager get instanceManager => this;
  @internal
  EventManager get eventManager => this;
  @internal
  Logger get logger => this;

  LogWriterCallback get log => defaultLogWriterCallback;
}

/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
/// ignore: non_constant_identifier_names
final Reactter = ReactterInterface();
