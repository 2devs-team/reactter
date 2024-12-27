import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/models/todo.dart';
import 'package:examples/examples/5_todo/stores/todo_store.dart';

class AddTodoAction extends RtActionCallable<TodoStore, Todo> {
  final Todo todo;

  const AddTodoAction({
    required this.todo,
  }) : super(
          type: 'ADD_TODO',
          payload: todo,
        );

  @override
  TodoStore call(TodoStore state) {
    return state.copyWith(
      todoList: [todo, ...state.todoList],
    );
  }
}
