import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/todo.dart';
import '../stores/todo_store.dart';

class AddTodoAction extends ReactterActionCallable<TodoStore, Todo> {
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
