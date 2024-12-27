part of '../internals.dart';

/// Represents an interface for the context of the application.
/// This interface provides access to various components and services used within the application.
///
/// The [IContext] interface includes the following properties:
/// - [dependencyInjection]: An instance of the [DependencyInjection] class that handles dependency injection.
/// - [stateManagement]: An instance of the [StateManagement] class that manages the state of the application.
/// - [eventHandler]: An instance of the [EventHandler] class that handles events within the application.
/// - [logger]: An instance of the [Logger] class that provides logging functionality.
abstract class IContext {
  @internal
  @protected
  DependencyInjection get dependencyInjection;

  @internal
  @protected
  StateManagement get stateManagement;

  @internal
  @protected
  EventHandler get eventHandler;
}
