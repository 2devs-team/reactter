part of '../framework.dart';

void defaultLogWriterCallback(
  String value, {
  Object? error,
  LogLevel? level = LogLevel.info,
}) {
  if (Rt.isLogEnable || error != null) {
    dev.log(value, name: 'REACTTER', error: error);
  }
}

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
        Logger,
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
  @internal
  Logger get logger => this;

  @override
  LogWriterCallback get log => defaultLogWriterCallback;
}

/// {@macro reactter.rt_interface}
@Deprecated(
  'Use `RtInterface` instead. '
  'This feature was deprecated after v7.3.0.',
)
typedef ReactterInterface = RtInterface;
