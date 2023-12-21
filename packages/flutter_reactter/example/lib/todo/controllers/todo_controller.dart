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
  final uReduce = UseReducer(
    _reducer,
    const TodoStore(
      todoList: [
        Todo(title: 'Learn Reactter'),
      ],
    ),
  );

  List<Todo> getTodosBy(TodoListType todoListType) {
    if (todoListType == TodoListType.all) return uReduce.value.todoList;

    final isDone = todoListType == TodoListType.done;

    return uReduce.value.todoList
        .where((todo) => todo.isDone == isDone)
        .toList();
  }

  void filterBy(TodoListType? todoListType) {
    uReduce.dispatch(
      FilterAction(
        todoListType: todoListType ?? TodoListType.all,
      ),
    );
  }

  void addTodo(String task) {
    uReduce.dispatch(
      AddTodoAction(
        todo: Todo(
          title: task.trim(),
        ),
      ),
    );
  }

  void removeTodo(Todo todo) {
    uReduce.dispatch(
      RemoveTodoAction(
        todo: todo,
      ),
    );
  }

  void toggleTodo(Todo todo) {
    uReduce.dispatch(
      ToggleTodoAction(
        todo: todo,
      ),
    );
  }

  void clearCompleted() {
    uReduce.dispatch(const ClearCompletedAction());
  }
}
