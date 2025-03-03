import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/models/todo.dart';
import 'package:examples/examples/5_todo/stores/todo_store.dart';

class ToggleTodoAction extends RtActionCallable<TodoStore, Todo> {
  final Todo todo;

  const ToggleTodoAction({required this.todo})
      : super(
          type: 'TOGGLE_TODO',
          payload: todo,
        );

  @override
  TodoStore call(TodoStore state) {
    final index = state.todoList.indexOf(todo);
    final todoList = List<Todo>.from(state.todoList);

    todoList[index] = todo.copyWith(isDone: !todo.isDone);

    return state.copyWith(
      todoList: todoList,
      doneCount: state.doneCount + (todo.isDone ? -1 : 1),
    );
  }
}
