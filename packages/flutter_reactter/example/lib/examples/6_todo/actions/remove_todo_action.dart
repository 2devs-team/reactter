import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/6_todo/models/todo.dart';
import 'package:examples/examples/6_todo/stores/todo_store.dart';

class RemoveTodoAction extends ReactterActionCallable<TodoStore, Todo> {
  final Todo todo;

  const RemoveTodoAction({
    required this.todo,
  }) : super(
          type: 'REMOVE_TODO',
          payload: todo,
        );

  @override
  TodoStore call(TodoStore state) {
    return state.copyWith(
      todoList: [
        for (final todo in state.todoList)
          if (this.todo != todo) todo
      ],
      doneCount: state.doneCount - (todo.isDone ? 1 : 0),
    );
  }
}
