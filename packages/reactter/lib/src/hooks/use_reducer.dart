part of 'hooks.dart';

/// {@template reactter.use_reducer}
/// A [RtHook] that manages state using [reducer] method.
///
/// [UseReducer] accepts a [reducer] method
///  and returns the current state paired with a [dispatch] method.
/// (If you’re familiar with Redux, you already know how this works.)
///
/// Contains a [value] of type [T] which represents the current state.
///
/// When [value] is different to previous state,
/// [UseReducer] execute [update] to notify to listeners
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
///  Store _reducer(Store state, RtAction<String, int?> action) {
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
///     state.dispatch(RtAction(type: 'increment', payload: 2));
///     print("count: ${state.value.count}"); // count: 2;
///     state.dispatch(RtAction(type: 'decrement'));
///     print("count: ${state.value.count}"); // count: 1;
///   }
/// }
/// ```
/// {@endtemplate}
class UseReducer<T> extends RtHook {
  @protected
  @override
  final $ = RtHook.$register;

  late final UseState<T> _state;

  /// Calculates a new state with state([T]) and action([RtAction]) given.
  final Reducer<T> reducer;

  T get value => _state.value;

  /// {@macro use_reducer}
  UseReducer(
    this.reducer,
    T initialState,
  ) : _state = UseState<T>(initialState) {
    UseEffect(update, [_state]);
  }

  /// Receives a [RtAction] and sends it to [reducer] method for resolved
  void dispatch<A extends RtAction>(A action) {
    _state.value = reducer(_state.value, action);
  }
}

/// {@template reactter.rt_action}
/// A representation of an event that describes something
/// that happened in the application.
///
/// A [RtAction] is composed of two properties:
///
/// - The [type] property, which provides this action a name that is descriptive.
/// - The [payload] property, which contain an action object type of [T]
///  that can provide additional information about what happened.
///
/// A typical [RtAction] might look like this:
///
/// ```dart
/// class AddTodoAction extends RtAction<String> {
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
/// * [UseReducer], a [RtHook] that manages state using [reducer] method.
/// {@endtemplate}
class RtAction<T> {
  // Provides this action a name that is descriptive.
  final String type;
  // An action object type of [T] that can provide
  // additional information about what happened
  final T payload;

  /// {@macro reactter.rt_action}
  const RtAction({
    required this.type,
    required this.payload,
  });
}

/// {@template reactter.rt_action_callable}
/// A abstract class of [RtAction] that may be called using a [call] method.
///
/// Example:
///
/// ```dart
/// class AddTodoAction extends RtActionCallable<Store, String> {
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
/// Store _reducer(Store state, RtAction action) =>
///   action is RtActionCallable ? action(state) : UnimplementedError()
///
/// final state = UseReducer(_reducer, Store());
///
/// state.dispatch(AddTodoAction('Todo this'));
/// ```
///
/// See also:
///
/// * [RtAction], a representation of an event that describes something
/// that happened in the application.
/// * [UseReducer], a [RtHook] that manages state using [reducer] method.
/// {@endtemplate}
abstract class RtActionCallable<T, P> extends RtAction<P> {
  const RtActionCallable({
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

/// {@macro reactter.rt_action}
@Deprecated('Use `RtAction` instead.')
typedef ReactterAction<T> = RtAction<T>;

/// {@macro reactter.rt_action_callable}
@Deprecated('Use `RtActionCallable` instead.')
typedef ReactterActionCallable = RtActionCallable;
