part of '../hooks.dart';

/// {@template use_state}
/// A [ReactterHook] that manages a state.
///
/// Contains a [value] of type [T] which represents the current state.
///
/// When [value] is different to previous state,
/// [UseState] execute [update] to notify container instance
/// that has changed and in turn executes [onWillUpdate] and [onDidUpdate].
///
/// This example produces one simple [UseState]:
///
/// ```dart
/// class AppController {
///   late final likesCount = UseState(0, this);
///   late final followed = UseState(false, this);
///   late final text = UseState("", this);
///   late final user = UseState<User?>(null, this);
///   late final posts = UseState(<Post>[], this);
///
///   AppController() {
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
/// {@endtemplate}
class UseState<T> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  /// {@macro use_state}
  UseState(T initialValue) : _value = initialValue;

  T _value;

  /// Get current value state
  T get value => _value;

  /// Set value state
  set value(T value) {
    if (value != _value || value.hashCode != _value.hashCode) {
      update(() => _value = value);
    }
  }
}
