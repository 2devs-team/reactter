part of '../hooks.dart';

/// A hook that manages state.
///
/// Contain a [value] of type [T] which represents the current state.
/// This [value] is set [initial] state on the firts parameter
/// and can be set a new [value] with operator `=`.
///
/// When [value] is different to previous state,
/// [UseState] execute [update] to notify [context] of [ReactterContext]
/// that has changed and in turn executes [onWillUpdate] and [onDidUpdate]
///
/// This example produces one simple [UseState] :
///
/// ```dart
/// class AppContext extends ReactterContext {
///   late final likesCount = UseState(0, this);
///   late final followed = UseState(false, this);
///   late final text = UseState("", this);
///   late final user = UseState<User?>(null, this);
///   late final posts = UseState(<Post>[], this);
///
///   AppContext() {
///     likesCount.value += 1;
///     followed.value = followed.value!;
///     text.value = "This is a text";
///     user.value = User(name: "name");
///
///     // It's need to force [update] because mantain the previous state
///     // and the [context] not aware that this state has changed
///     posts.update(() {
///       posts.value.add(
///           Post(
///             user: user.value,
///             text: text.value,
///           ),
///         );
///     });
///   }
/// }
/// ```
///
/// See also:
/// - [ReactterContext], a context that contains any logic and allowed react
/// when any change the [ReactterHook].
class UseState<T> extends ReactterHook {
  UseState(
    this.initial, [
    ReactterHookManager? context,
  ]) : super(context);

  /// The initial value in state.
  T initial;

  late T _value = initial;

  /// Get current value state
  T get value => _value;

  /// Set value state
  set value(T value) {
    if (value != _value || value.hashCode != _value.hashCode) {
      update(() {
        _value = value;
      });
    }
  }

  /// Reset the state to initial value
  void reset() {
    value = initial;
  }
}
