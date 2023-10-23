part of '../hooks.dart';

/// {@template reactter_action}
/// A representation of an event that describes something
/// that happened in the application.
///
/// A [ReactterAction] is composed of two properties:
///
/// - The [type] property, which provides this action a name that is descriptive.
/// - The [payload] property, which contain an action object type of [T]
///  that can provide additional information about what happened.
///
/// A typical [ReactterAction] might look like this:
///
/// ```dart
/// class AddTodoAction extends ReactterAction<String> {
///   AddTodoAction(String payload)
///     : super(
///         type: 'todo/todoAdded',
///         payload: payload,
///       );
/// }
/// ```
/// and use with [UseReducer] `dispatch`, like:
///
/// ```dart
/// // Consult `UseReducer` for more information about `reducer` and `store`.
/// final state = UseReducer(reducer, store);
/// state.dispatch(AddTodoAction('Todo this'));
/// ```
///
/// See also:
///
/// * [UseReducer], a [ReactterHook] that manages state using [reducer] method.
/// {@endtemplate}
class ReactterAction<T> {
  // Provides this action a name that is descriptive.
  final String type;
  // An action object type of [T] that can provide
  // additional information about what happened
  final T payload;

  /// {@macro reactter_action}
  const ReactterAction({
    required this.type,
    required this.payload,
  });
}

/// A abstract class of [ReactterAction] that may be called using a [call] method.
///
/// Example:
///
/// ```dart
/// class AddTodoAction extends ReactterActionCallable<Store, String> {
///   AddTodoAction(String payload)
///     : super(
///         type: 'todo/todoAdded',
///         payload: payload,
///       );
///
///   Store call(state) {
///     return state.copyWith(
///       todo: state.todo..add(payload),
///     );
///   }
/// }
///
/// Store _reducer(Store state, ReactterAction action) =>
///   action is ReactterActionCallable ? action(state) : UnimplementedError()
///
/// final state = UseReducer(_reducer, Store());
///
/// state.dispatch(AddTodoAction('Todo this'));
/// ```
///
/// See also:
///
/// * [ReactterAction], a representation of an event that describes something
/// that happened in the application.
/// * [UseReducer], a [ReactterHook] that manages state using [reducer] method.
abstract class ReactterActionCallable<T, P> extends ReactterAction<P> {
  const ReactterActionCallable({
    required String type,
    required P payload,
  }) : super(
          type: type,
          payload: payload,
        );

  /// This method is called when the action is dispatched and is responsible
  /// for updating the state based on the action's payload.
  ///
  /// Takes a parameter of type [T] (which represents the current state)
  /// and returns a value of type [T] (which represents the new state after
  /// the action has been applied).
  T call(T state);
}

//// {@template use_reducer}
/// A [ReactterHook] that manages state using [reducer] method.
///
/// [UseReducer] accepts a [reducer] method
///  and returns the current state paired with a [dispatch] method.
/// (If you’re familiar with Redux, you already know how this works.)
///
/// Contains a [value] of type [T] which represents the current state.
///
/// When [value] is different to previous state,
/// [UseReducer] execute [update] to notify to container instance
/// that has changed and in turn executes [onWillUpdate] and [onDidUpdate].
///
/// Example:
///
/// ```dart
/// class Store {
///   final int count;
///
///   Store({this.count = 0});
/// }
///
///  Store _reducer(Store state, ReactterAction<String, int?> action) {
///    switch (action.type) {
///      case 'increment':
///        return Store(count: state.count + (action.payload ?? 1));
///      case 'decrement':
///        return Store(count: state.count + (action.payload ?? 1));
///      default:
///        throw UnimplementedError();
///    }
///  }
///
/// class AppController {
///   late final state = UseReducer(_reducer, Store(count: 0));
///
///   AppController() {
///     print("count: ${state.value.count}"); // count: 0;
///     state.dispatch(ReactterAction(type: 'increment', payload: 2));
///     print("count: ${state.value.count}"); // count: 2;
///     state.dispatch(ReactterAction(type: 'decrement'));
///     print("count: ${state.value.count}"); // count: 1;
///   }
/// }
/// ```
/// {@endtemplate}
class UseReducer<T> extends ReactterHook {
  @protected
  @override
  final $ = ReactterHook.$register;

  late final UseState<T> _state;

  /// Calculates a new state with state([T]) and action([ReactterAction]) given.
  final Reducer<T> reducer;

  T get value => _state.value;

  /// {@macro use_reducer}
  UseReducer(
    this.reducer,
    T initialState,
  ) : _state = UseState<T>(initialState) {
    UseEffect(update, [_state]);
  }

  /// Receives a [ReactterAction] and sends it to [reducer] method for resolved
  void dispatch<A extends ReactterAction>(A action) {
    _state.value = reducer(_state.value, action);
  }
}
