part of '../internals.dart';

@internal
abstract class Notifier<T extends Function> {
  int _count = 0;
  // The _listeners is intentionally set to a fixed-length _GrowableList instead
  // of const [].
  //
  // The const [] creates an instance of _ImmutableList which would be
  // different from fixed-length _GrowableList used elsewhere in this class.
  // keeping runtime type the same during the lifetime of this class lets the
  // compiler to infer concrete type for this property, and thus improves
  // performance.
  static final List<Function?> _emptyListeners =
      List<Function?>.filled(0, null);
  List<T?> _listeners = _emptyListeners as List<T?>;
  final _listenersSingleUse = <T>{};

  int _notificationCallStackDepth = 0;
  int _reentrantlyRemovedListeners = 0;
  bool _debugDisposed = false;

  String get target;

  /// Copied from Flutter
  /// Used by subclasses to assert that the [Notifier] has not yet been
  /// disposed.
  ///
  /// {@tool snippet}
  /// The [debugAssertNotDisposed] function should only be called inside of an
  /// assert, as in this example.
  ///
  /// ```dart
  /// class MyNotifier with Notifier {
  ///   void doUpdate() {
  ///     assert(ReacterNotifier.debugAssertNotDisposed(this));
  ///     // ...
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  // This is static and not an instance method because too many people try to
  // implement Notifier instead of extending it (and so it is too breaking
  // to add a method, especially for debug).
  // coverage:ignore-start
  static bool debugAssertNotDisposed(Notifier notifier) {
    assert(() {
      if (notifier._debugDisposed) {
        throw AssertionError(
          'A ${notifier.runtimeType} was used after being disposed.\n'
          'Once you have called dispose() on a ${notifier.runtimeType}, it '
          'can no longer be used.',
        );
      }
      return true;
    }());
    return true;
  }
  // coverage:ignore-end

  /// Copied from Flutter
  /// Whether any listeners are currently registered.
  ///
  /// Clients should not depend on this value for their behavior, because having
  /// one listener's logic change when another listener happens to start or stop
  /// listening will lead to extremely hard-to-track bugs. Subclasses might use
  /// this information to determine whether to do any work when there are no
  /// listeners, however; for example, resuming a [Stream] when a listener is
  /// added and pausing it when a listener is removed.
  ///
  /// Typically this is used by overriding [addListener], checking if
  /// [hasListeners] is false before calling `super.addListener()`, and if so,
  /// starting whatever work is needed to determine when to call
  /// [notifyListeners]; and similarly, by overriding [removeListener], checking
  /// if [hasListeners] is false after calling `super.removeListener()`, and if
  /// so, stopping that same work.
  ///
  /// This method returns false if [dispose] has been called.
  @protected
  bool get hasListeners => _count > 0;

  /// Copied from Flutter
  /// Register a closure to be called when the object changes.
  ///
  /// If the given closure is already registered, an additional instance is
  /// added, and must be removed the same number of times it is added before it
  /// will stop being called.
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// {@template reactter.Notifier.addListener}
  /// If a listener is added twice, and is removed once during an iteration
  /// (e.g. in response to a notification), it will still be called again. If,
  /// on the other hand, it is removed as many times as it was registered, then
  /// it will no longer be called. This odd behavior is the result of the
  /// [Notifier] not being able to determine which listener is being
  /// removed, since they are identical, therefore it will conservatively still
  /// call all the listeners when it knows that any are still registered.
  ///
  /// This surprising behavior can be unexpectedly observed when registering a
  /// listener on two separate objects which are both forwarding all
  /// registrations to a common upstream object.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [removeListener], which removes a previously registered closure from
  ///    the list of closures that are notified when the object changes.
  void addListener(T listener, [bool singleUse = false]) {
    assert(Notifier.debugAssertNotDisposed(this));

    if (_count == _listeners.length) {
      if (_count == 0) {
        _listeners = List<T?>.filled(1, null);
      } else {
        final newListeners = List<T?>.filled(
          _listeners.length * 2,
          null,
        );

        for (int i = 0; i < _count; i++) {
          newListeners[i] = _listeners[i];
        }

        _listeners = newListeners;
      }
    }

    _listeners[_count++] = listener;

    if (singleUse) {
      _listenersSingleUse.add(listener);
    }
  }

  /// Copied from Flutter
  // coverage:ignore-start
  void _removeAt(int index) {
    // The list holding the listeners is not growable for performances reasons.
    // We still want to shrink this list if a lot of listeners have been added
    // and then removed outside a notifyListeners iteration.
    // We do this only when the real number of listeners is half the length
    // of our list.
    _count -= 1;
    if (_count * 2 <= _listeners.length) {
      final newListeners = List<T?>.filled(_count, null);

      // Listeners before the index are at the same place.
      for (int i = 0; i < index; i++) {
        newListeners[i] = _listeners[i];
      }

      // Listeners after the index move towards the start of the list.
      for (int i = index; i < _count; i++) {
        newListeners[i] = _listeners[i + 1];
      }

      _listeners = newListeners;
    } else {
      // When there are more listeners than half the length of the list, we only
      // shift our listeners, so that we avoid to reallocate memory for the
      // whole list.
      for (int i = index; i < _count; i++) {
        _listeners[i] = _listeners[i + 1];
      }
      _listeners[_count] = null;
    }
  }
  // coverage:ignore-end

  /// Copied from Flutter
  /// Remove a previously registered closure from the list of closures that are
  /// notified when the object changes.
  ///
  /// If the given listener is not registered, the call is ignored.
  ///
  /// This method returns immediately if [dispose] has been called.
  ///
  /// See also:
  ///
  ///  * [addListener], which registers a closure to be called when the object
  ///    changes.
  void removeListener(Function listener) {
    if (_listenersSingleUse.contains(listener)) {
      _listenersSingleUse.remove(listener);
    }

    // This method is allowed to be called on disposed instances for usability
    // reasons. Due to how our frame scheduling logic between render objects and
    // overlays, it is common that the owner of this instance would be disposed a
    // frame earlier than the listeners. Allowing calls to this method after it
    // is disposed makes it easier for listeners to properly clean up.
    for (int i = 0; i < _count; i++) {
      final Function? listenerAtIndex = _listeners[i];
      if (listenerAtIndex == listener) {
        if (_notificationCallStackDepth > 0) {
          // We don't resize the list during notifyListeners iterations
          // but we set to null, the listeners we want to remove. We will
          // effectively resize the list at the end of all notifyListeners
          // iterations.
          _listeners[i] = null;

          _reentrantlyRemovedListeners++;
        } else {
          // When we are outside the notifyListeners iterations we can
          // effectively shrink the list.
          _removeAt(i);
        }

        break;
      }
    }
  }

  /// Copied from Flutter
  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] will throw after the object is disposed).
  ///
  /// This method should only be called by the object's owner.
  ///
  /// This method does not notify listeners, and clears the listener list once
  /// it is called. Consumers of this class must decide on whether to notify
  /// listeners or not immediately before disposal.
  @mustCallSuper
  void dispose() {
    assert(Notifier.debugAssertNotDisposed(this));
    assert(
      _notificationCallStackDepth == 0,
      'The "dispose()" method on $this was called during the call to '
      '"notifyListeners()". This is likely to cause errors since it modifies '
      'the list of listeners while the list is being used.',
    );
    assert(() {
      _debugDisposed = true;
      return true;
    }());

    _listeners = _emptyListeners as List<T?>;
    _count = 0;
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
  @protected
  @visibleForTesting
  void notifyListeners(Object? param) {
    assert(Notifier.debugAssertNotDisposed(this));

    if (_count == 0) {
      return;
    }

    // To make sure that listeners removed during this iteration are not called,
    // we set them to null, but we don't shrink the list right away.
    // By doing this, we can continue to iterate on our list until it reaches
    // the last listener added before the call to this method.

    // To allow potential listeners to recursively call notifyListener, we track
    // the number of times this method is called in _notificationCallStackDepth.
    // Once every recursive iteration is finished (i.e. when _notificationCallStackDepth == 0),
    // we can safely shrink our list so that it will only contain not null
    // listeners.

    _notificationCallStackDepth++;

    final int end = _count;
    Object? error;

    for (int i = 0; i < end; i++) {
      final listener = _listeners[i];

      if (listener == null) continue;

      try {
        if (_listenersSingleUse.contains(listener)) {
          _listenersSingleUse.remove(listener);
          removeListener(listener);
        }

        listenerCall(listener, param);
      } catch (err) {
        error = err;
      } finally {
        // ignore: control_flow_in_finally
        continue;
      }
    }

    _notificationCallStackDepth--;

    // coverage:ignore-start
    // No coverage for the following block because it is only used for
    // performance optimization.
    if (_notificationCallStackDepth == 0 && _reentrantlyRemovedListeners > 0) {
      // We really remove the listeners when all notifications are done.
      final int newLength = _count - _reentrantlyRemovedListeners;
      if (newLength * 2 <= _listeners.length) {
        // As in _removeAt, we only shrink the list when the real number of
        // listeners is half the length of our list.
        final List<T?> newListeners = List<T?>.filled(newLength, null);

        int newIndex = 0;
        for (int i = 0; i < _count; i++) {
          final T? listener = _listeners[i];
          if (listener != null) {
            newListeners[newIndex++] = listener;
          }
        }

        _listeners = newListeners;
      } else {
        // Otherwise we put all the null references at the end.
        for (int i = 0; i < newLength; i += 1) {
          if (_listeners[i] == null) {
            // We swap this item with the next not null item.
            int swapIndex = i + 1;
            while (_listeners[swapIndex] == null) {
              swapIndex += 1;
            }
            _listeners[i] = _listeners[swapIndex];
            _listeners[swapIndex] = null;
          }
        }
      }
      // coverage:ignore-end

      _reentrantlyRemovedListeners = 0;
      _count = newLength;
    }

    assert(() {
      if (error == null) return true;

      throw AssertionError(
        'An error was thrown by a listener of $target.\n'
        'The error thrown was:\n'
        '  $error\n',
      );
    }());
  }

  /// Calls the [listener] with the given [param].
  /// Override this method to provide custom behavior when notifying listeners.
  void listenerCall(T? listener, Object? param);
}
