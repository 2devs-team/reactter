part of 'core.dart';

/// A abstract-class that adds events management features to classes that use it.
///
/// It contains methods for adding, removing, and triggering events,
/// as well as storing event callbacks.
@internal
abstract class EventManager {
  @internal
  InstanceManager get instanceManager;

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

    if (notifier == null) return;

    notifier.notifyListeners(param);
  }

  /// Removes all instance's events
  void offAll(Object? instance) {
    final notifiers = _notifiers.where((notifier) => notifier == instance);

    for (final notifier in {...notifiers}) {
      notifier.dispose();
      _notifiers.remove(notifier);
    }
  }

  /// Checks if an object has any listeners.
  bool _hasListeners(Object? instance) {
    return _notifiers.any((notifier) => notifier == instance);
  }

  /// Retrieves the [EventNotifier] for the given [instance] and [eventName].
  /// If the [EventNotifier] does not exist in the lookup table, it creates a new one.
  EventNotifier _getEventNotifierFallback(Object? instance, Enum eventName) {
    final notifier = EventNotifier(
      instanceManager,
      instance,
      eventName,
      _offEventNotifier,
    );

    return _notifiers.lookup(notifier) ?? notifier;
  }

  /// Retrieves the [EventNotifier] for the given [instance] and [eventName].
  /// If the [EventNotifier] does not exist in the lookup table, it creates a new one.
  EventNotifier? _getEventNotifier(Object? instance, Enum eventName) {
    final notifier = EventNotifier(
      instanceManager,
      instance,
      eventName,
      _offEventNotifier,
    );

    return _notifiers.lookup(notifier);
  }

  void _offEventNotifier(EventNotifier notifier) {
    if (notifier.hasListeners) return;

    notifier.dispose();
    _notifiers.remove(notifier);
  }
}
