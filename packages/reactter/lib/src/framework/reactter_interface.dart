// ignore_for_file: non_constant_identifier_names

part of 'framework.dart';

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
    with StateManagement<RtState>, DependencyInjection, EventHandler, Logger {
  static final _reactterInterface = RtInterface._();
  factory RtInterface() => _reactterInterface;
  RtInterface._();

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

/// {@template reactter.rt}
/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
/// {@endtemplate}
final Rt = RtInterface();

/// {@macro reactter.rt_interface}
@Deprecated('Use `RtInterface` instead')
typedef ReactterInterface = RtInterface;

/// {@macro reactter.rt}
@Deprecated('Use `Rt` instead')
final Reactter = Rt;
