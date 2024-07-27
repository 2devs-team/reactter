import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/6_todo/actions/add_todo_action.dart';
import 'package:examples/examples/6_todo/actions/clear_completed_action.dart';
import 'package:examples/examples/6_todo/actions/filter_action.dart';
import 'package:examples/examples/6_todo/actions/remove_todo_action.dart';
import 'package:examples/examples/6_todo/actions/toggle_todo_action.dart';
import 'package:examples/examples/6_todo/models/todo.dart';
import 'package:examples/examples/6_todo/stores/todo_store.dart';

TodoStore _reducer(TodoStore state, RtAction action) {
  return action is RtActionCallable ? action(state) : UnimplementedError();
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
