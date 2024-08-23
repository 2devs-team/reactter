// ignore_for_file: non_constant_identifier_names

part of '../framework.dart';

/// {@template reactter.rt}
/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
/// {@endtemplate}
final Rt = RtInterface();

mixin RtContext implements IContext {
  @override
  @internal
  DependencyInjection get dependencyInjection => Rt;

  @override
  @internal
  StateManagement get stateManagement => Rt;

  @override
  @internal
  EventHandler get eventHandler => Rt;

  @override
  @internal
  Logger get logger => Rt;
}

/// {@macro reactter.rt}
@Deprecated(
  'Use `Rt` instead. '
  'This feature was deprecated after v7.3.0.',
)
final Reactter = Rt;
