part of '../hooks.dart';

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
///
class UseState<T> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  UseState(T initialValue)
      : _value = initialValue,
        // ignore: deprecated_member_use_from_same_package
        initial = initialValue;

  /// The initial value in state.
  @Deprecated(
    'No longer used by the framework, please remove any reference to it. '
    'This feature was deprecated after v6.0.0.pre.',
  )
  final T initial;

  T _value;

  /// Get current value state
  T get value => _value;

  /// Set value state
  set value(T value) {
    if (value != _value || value.hashCode != _value.hashCode) {
      update(() => _value = value);
    }
  }

  // coverage:ignore-start
  /// Reset the state to initial value
  @Deprecated(
    "No longer used by the framework. "
    'This feature was deprecated after v6.0.0.pre.',
  )
  void reset() => value = initial;
  // coverage:ignore-end
}
