part of '../internals.dart';

/// A class that represents an event notifier reference for the [EventHandler].
class EventNotifierRef {
  final DependencyRef? _dependencyRef;
  final Object? _instanceObj;
  final Enum event;

  EventNotifierRef(
    Object? dependencyOrObj,
    this.event,
  )   : _dependencyRef =
            dependencyOrObj is DependencyRef ? dependencyOrObj : null,
        _instanceObj =
            dependencyOrObj is! DependencyRef ? dependencyOrObj : null;

  @override
  int get hashCode => Object.hash(
        _dependencyRef.hashCode,
        _instanceObj.hashCode,
        event.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is! EventNotifierRef) {
      return false;
    }

    if (other.event != event) {
      return false;
    }

    if (_dependencyRef != null && other._dependencyRef != null) {
      return _dependencyRef == other._dependencyRef;
    }

    return _instanceObj == other._instanceObj;
  }
}

/// A class that represents an event notifier.
///
/// An event notifier is responsible for managing listeners and notifying them
/// when an event occurs. It keeps track of the registered listeners and provides
/// methods to add and remove listeners. When an event occurs, the event notifier
/// calls all the registered listeners.
///
/// The event notifier can be disposed using the [dispose] method. Once disposed,
/// it cannot be used anymore and any calls to [addListener] will throw an error.
///
/// Subclasses can override the [notifyListeners] method to provide custom
/// behavior when notifying listeners.
///
@internal
class EventNotifier extends EventNotifierRef with Notifier {
  final DependencyInjection dependencyInjection;
  @override
  String get target => "$instanceObj about $event";
  final void Function(EventNotifier notifier) onNotifyComplete;

  DependencyRef? get instanceRef =>
      _dependencyRef ?? dependencyInjection._getDependencyRef(_instanceObj);

  Object? get instanceObj =>
      _instanceObj ??
      dependencyInjection._getDependencyRegisterByRef(_dependencyRef)?.instance;

  EventNotifier(
    Object? instanceOrObj,
    Enum event,
    this.dependencyInjection,
    this.onNotifyComplete,
  ) : super(instanceOrObj, event);

  @override
  int get hashCode => Object.hash(
        _dependencyRef.hashCode,
        _instanceObj.hashCode,
        event.hashCode,
      );

  @override
  bool operator ==(Object other) {
    if (other is EventNotifierRef) {
      return super == other;
    }

    if (other is DependencyRef) {
      return instanceRef == other;
    }

    final instanceRefSelf = instanceRef;

    if (instanceRefSelf != null) {
      return instanceRefSelf == dependencyInjection._getDependencyRef(other);
    }

    return instanceObj == other;
  }

  /// Copied from Flutter
  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have changed. Listeners that are added during this iteration
  /// will not be visited. Listeners that are removed during this iteration will
  /// not be visited after they are removed.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (e.g.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeListener].
  @override
  @protected
  @visibleForTesting
  void notifyListeners(Object? param) {
    try {
      super.notifyListeners(param);
    } catch (e) {
      if (e is! AssertionError) rethrow;
    } finally {
      onNotifyComplete(this);
    }
  }

  @override
  void listenerCall(Function? listener, Object? param) {
    listener?.call(instanceObj, param);
  }
}
