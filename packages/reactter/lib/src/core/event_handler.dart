part of '../internals.dart';

/// A abstract-class that adds event handler features to classes that use it.
///
/// It contains methods for adding, removing, and triggering events,
/// as well as storing event callbacks.
@internal
abstract class EventHandler implements IContext {
  final _notifiers = HashSet<EventNotifier>();

  /// Puts on to listen [eventName] event.
  ///
  /// When the event is emitted(by [emit]), the [callback] is called.
  void on<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    final notifier = _getEventNotifierFallback(instance, eventName);
    notifier.addListener(callback);
    _notifiers.add(notifier);
  }

  /// Puts on to listen [eventName] event only once.
  ///
  /// When the event is emitted(by [emit]), the [callback] is called
  /// and after removes event.
  void one<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    final notifier = _getEventNotifierFallback(instance, eventName);
    notifier.addListener(callback, true);
    _notifiers.add(notifier);
  }

  /// Removes the [callback] of [eventName].
  void off<T, P>(
    Object? instance,
    Enum eventName,
    CallbackEvent<T, P> callback,
  ) {
    final notifier = _getEventNotifier(instance, eventName);

    if (notifier == null) return;

    notifier.removeListener(callback);
    _offEventNotifier(notifier);
  }

  /// Trigger [eventName] event with or without the [param] given.
  void emit(
    Object? instance,
    Enum eventName, [
    dynamic param,
  ]) {
    final notifier = _getEventNotifier(instance, eventName);
    final notifierPartner = _getEventNotifierPartner(instance, eventName);

    if (eventName is Lifecycle) {
      _resolveLifecycleEvent(instance, eventName, param);
    }

    if (notifier?._dependencyRef == null) {
      notifier?.notifyListeners(param);
      notifierPartner?.notifyListeners(param);
    } else {
      notifierPartner?.notifyListeners(param);
      notifier?.notifyListeners(param);
    }

    if (eventName is Lifecycle) {
      _notifyToObservers(instance, eventName, param);
    }
  }

  /// Removes all instance's events
  void offAll(Object? instance, [bool generic = false]) {
    final notifiers = _notifiers.where((notifier) {
      if (!generic && notifier._dependencyRef != null) return false;

      return instance != null && notifier.isInstanceOrDependencyRef(instance);
    });

    final boundInstance = instance is RtState ? instance.boundInstance : null;

    for (final notifier in notifiers.toList(growable: false)) {
      if (boundInstance != null &&
          notifier.isInstanceOrDependencyRef(boundInstance)) {
        continue;
      }

      notifier.dispose();
      _notifiers.remove(notifier);
      stateManagement._deferredEvents.remove(notifier);
    }
  }

  /// Checks if an object has any listeners.
  bool _hasListeners(Object? instance) {
    return instance != null &&
        _notifiers.any(
          (notifier) => notifier.isInstanceOrDependencyRef(instance),
        );
  }

  /// Retrieves the [EventNotifier] for the given [instance] and [eventName].
  /// If the [EventNotifier] does not exist in the lookup table, it creates a new one.
  EventNotifier _getEventNotifierFallback(Object? instance, Enum eventName) {
    return _notifiers.lookup(EventNotifierRef(instance, eventName)) ??
        EventNotifier(
          instance,
          eventName,
          dependencyInjection,
          _offEventNotifier,
        );
  }

  /// Retrieves the [EventNotifier] for the given [instance] and [eventName].
  /// If the [EventNotifier] does not exist in the lookup table, it creates a new one.
  EventNotifier? _getEventNotifier(Object? instance, Enum eventName) {
    return _notifiers.lookup(EventNotifierRef(instance, eventName));
  }

  /// Retrieves the [EventNotifier] partner for the given [instance] and [eventName].
  /// If the [EventNotifier] does not exist in the lookup table, it creates a new one.
  EventNotifier? _getEventNotifierPartner(Object? instance, Enum eventName) {
    final instancePartner = instance is DependencyRef
        ? dependencyInjection.getDependencyRegisterByRef(instance)?.instance
        : dependencyInjection.getDependencyRef(instance);

    if (instancePartner == null) return null;

    return _notifiers.lookup(EventNotifierRef(instancePartner, eventName));
  }

  /// Removes the [EventNotifier] from the lookup table if it has no listeners.
  void _offEventNotifier(EventNotifier notifier) {
    if (notifier.hasListeners) return;

    notifier.dispose();
    _notifiers.remove(notifier);
  }

  /// Resolves the lifecycle event for the given [instance].
  void _resolveLifecycleEvent(
    Object? instance,
    Lifecycle lifecycle, [
    dynamic param,
  ]) {
    final instanceObj = instance is DependencyRef
        ? dependencyInjection.getDependencyRegisterByRef(instance)?.instance
        : instance;

    if (instanceObj is LifecycleObserver) {
      _executeLifecycleObserver(instanceObj, lifecycle, param);
    }
  }

  void _notifyToObservers(
    Object? instanceOrDependencyRef,
    Lifecycle lifecycle,
    dynamic param,
  ) {
    final dependencyRef = instanceOrDependencyRef is DependencyRef
        ? instanceOrDependencyRef
        : dependencyInjection.getDependencyRef(instanceOrDependencyRef);

    final instance = param is Object
        ? param
        : dependencyInjection
            .getDependencyRegisterByRef(dependencyRef)
            ?.instance;

    if (dependencyRef == null) return;

    for (final observer
        in IDependencyObserver._observers.toList(growable: false)) {
      switch (lifecycle) {
        case Lifecycle.registered:
          observer.onDependencyRegistered(dependencyRef);
          break;
        case Lifecycle.created:
          observer.onDependencyCreated(dependencyRef, instance);
          break;
        case Lifecycle.didMount:
          observer.onDependencyMounted(dependencyRef, instance);
          break;
        case Lifecycle.didUnmount:
          observer.onDependencyUnmounted(dependencyRef, instance);
          break;
        case Lifecycle.deleted:
          observer.onDependencyDeleted(dependencyRef, instance);
          break;
        case Lifecycle.unregistered:
          observer.onDependencyUnregistered(dependencyRef);
          break;
        default:
          break;
      }
    }
  }
}
