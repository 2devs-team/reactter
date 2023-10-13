import 'package:flutter_reactter/flutter_reactter.dart';

import '../actions/add_todo_action.dart';
import '../actions/clear_completed_action.dart';
import '../actions/filter_action.dart';
import '../actions/remove_todo_action.dart';
import '../actions/toggle_todo_action.dart';
import '../models/todo.dart';
import '../stores/todo_store.dart';

TodoStore _reducer(TodoStore state, ReactterAction action) {
  return action is ReactterActionCallable
      ? action(state)
      : UnimplementedError();
}

class TodoController {
  final state = UseReducer(
    _reducer,
    const TodoStore(
      todoList: [
        Todo(title: 'Learn Reactter'),
      ],
    ),
  );

  late final todoListFiltered = Reactter.lazy(
    () => UseCompute(
      () => getTodosBy(state.value.filterBy),
      [state],
    ),
    this,
  );

  late final todoActiveCount = Reactter.lazy(
    () => UseCompute(
      () => state.value.todoList.fold<int>(
        0,
        (acc, todo) => acc + (todo.isDone ? 0 : 1),
      ),
      [state],
    ),
    this,
  );

  List<Todo> getTodosBy(TodoListType todoListType) {
    if (todoListType == TodoListType.todo) {
      return state.value.todoList.where((todo) => !todo.isDone).toList();
    }

    if (todoListType == TodoListType.done) {
      return state.value.todoList.where((todo) => todo.isDone).toList();
    }

    return state.value.todoList;
  }

  void filterBy(TodoListType? todoListType) {
    state.dispatch(
      FilterAction(
        todoListType: todoListType ?? TodoListType.all,
      ),
    );
  }

  void addTodo(String task) {
    state.dispatch(
      AddTodoAction(
        todo: Todo(
          title: task.trim(),
        ),
      ),
    );
  }

  void removeTodo(Todo todo) {
    state.dispatch(
      RemoveTodoAction(
        todo: todo,
      ),
    );
  }

  void toggleTodo(Todo todo) {
    state.dispatch(
      ToggleTodoAction(
        todo: todo,
      ),
    );
  }

  void clearCompleted() {
    state.dispatch(const ClearCompletedAction());
  }
}
