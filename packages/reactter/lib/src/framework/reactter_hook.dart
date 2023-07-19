part of '../framework.dart';

/// An abstract-class that provides the functionality of [ReactterNotifyManager]
/// and [ReactterState].
///
/// This is an example of how to create a custom hook:
///
///```dart
/// class UseToggle extends ReactterHook {
///   final $ = ReactterHook.$register;
///   final _state = UseState(false);
///
///   bool get value => _state.value;
///
///   UseToggle(bool initial) {
///     _state.value = initial;
///   }
///
///   void toggle() => _state.value = !_state.value;
/// }
/// ```
/// > **IMPORTANT**: All [ReactterHook] must be registered using the final [$] variable.
///
/// and use it like this:
///
///```dart
/// class AppController {
///   final state = UseToggle(false);
///
///   UserContext() {
///     print('initial value: ${state.value}');
///
///     state.toggle();
///
///     print('toggle value: ${state.value}');
///   }
/// }
/// ```
///
/// See also:
///
/// * [ReactterNotifyManager], provides methods that notify listeners
/// about [ReactterHook] changes.
/// * [ReactterState], adds state management features to [ReactterHook].
abstract class ReactterHook with ReactterState {
  /// This variable is used to register [ReacttrHook]
  /// and attach the [ReactterState] that are defined here.
  ///
  /// It must be defined as a final variable
  /// and set with [ReactterHook.$register].
  /// Like so:
  ///
  /// `final $ = ReactterHook.$register;`
  _RegisterHook get $;

  /// This getter allows access to the [_RegisterHook] instance
  /// which is responsible for registering a [ReactterHook]
  /// and attaching previously collected states to it.
  static _RegisterHook get $register => _RegisterHook();

  ReactterHook() {
    $._register(this);
    createState();
  }

  /// Executes [callback], and notify the listeners about to update.
  @mustCallSuper
  void update([Function? callback]) {
    return super.update(callback ?? () {});
  }

  /// Executes [callback], and notify the listeners about to update as async way.
  @mustCallSuper
  Future<void> updateAsync([Function? callback]) async {
    return super.updateAsync(callback ?? () {});
  }
}

/// It is responsible for registering a [ReactterHook] and attaching previously
/// collected states to it.
class _RegisterHook {
  bool _isRegistered = false;

  final _prevStatesRecollected = _getAndCleanStatesRecollected();

  /// The function is used to retrieve and clean collected states.
  static _getAndCleanStatesRecollected() {
    final states = [...Reactter._statesRecollected];
    Reactter._statesRecollected.clear();
    return states;
  }

  /// The function registers a ReactterHook.
  void _register(ReactterHook hook) {
    assert(!_isRegistered, "Can't call register method again");

    _isRegistered = true;

    Reactter._statesRecollected.forEach((state) {
      state.attachTo(hook);
    });

    Reactter._statesRecollected
      ..clear()
      ..addAll(_prevStatesRecollected);
  }
}
