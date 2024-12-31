// ignore_for_file: non_constant_identifier_names

part of '../framework.dart';

/// {@template reactter.rt}
/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
/// {@endtemplate}
final Rt = RtInterface();

mixin RtContextMixin implements IContext {
  @override
  @internal
  DependencyInjection get dependencyInjection => Rt;

  @override
  @internal
  StateManagement get stateManagement => Rt;

  @override
  @internal
  EventHandler get eventHandler => Rt;
}
