part of '../hooks.dart';

class ReactterAction<T, P> {
  final T type;
  final P payload;

  ReactterAction({
    required this.type,
    required this.payload,
  });
}

abstract class ReactterActionCallable<T, P> extends ReactterAction<String, P> {
  ReactterActionCallable({required String type, required P payload})
      : super(type: type, payload: payload);

  T call(T state);
}

/// A [ReactterHook] that manages state using [reducer] method.
///
/// [UseReducer] accepts a [reducer] method
///  and returns the current state paired with a [dispatch] method.
/// (If you’re familiar with Redux, you already know how this works.)
///
/// Contains a [value] of type [T] which represents the current state.
///
/// When [value] is different to previous state,
/// [UseReducer] execute [update] to notify [context] of [ReactterContext]
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
/// class AppContext extends ReactterContext {
///   late final state = UseReducer(_reducer, Store(count: 0), this);
///
///   AppContext() {
///     print("count: ${state.value.count}"); // count: 0;
///     state.dispatch(ReactterAction(type: 'increment', payload: 2));
///     print("count: ${state.value.count}"); // count: 2;
///     state.dispatch(ReactterAction(type: 'decrement'));
///     print("count: ${state.value.count}"); // count: 1;
///   }
/// }
/// ```
/// See also:
/// - [ReactterContext], a context that contains any logic and allowed react
/// when any change the [ReactterHook].
class UseReducer<T> extends ReactterHook {
  late final UseState<T> _state;

  /// Calculates a new state with state([T]) and action([ReactterAction]) given.
  final Reducer<T> reducer;

  T get value => _state.value;

  UseReducer(
    this.reducer,
    T initialState, [
    ReactterHookManager? context,
  ])  : _state = UseState<T>(initialState),
        super(context) {
    UseEffect(update, [_state]);
  }

  /// Receives a [ReactterAction] and sends it to [reducer] method for resolved
  dispatch<A extends ReactterAction>(A action) =>
      _state.value = reducer(_state.value, action);
}
