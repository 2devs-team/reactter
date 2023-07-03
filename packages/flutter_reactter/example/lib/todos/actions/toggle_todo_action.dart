import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/todo.dart';
import '../stores/todos_store.dart';

class ToggleTodoAction extends ReactterActionCallable<TodosStore, Todo> {
  final Todo todo;

  ToggleTodoAction({required this.todo})
      : super(
          type: 'TOGGLE_TODO',
          payload: todo,
        );

  @override
  TodosStore call(TodosStore state) {
    final index = state.todos.indexOf(todo);

    state.todos.replaceRange(index, index + 1, [
      todo.copyWith(isDone: !todo.isDone),
    ]);

    return state.copyWith();
  }
}
