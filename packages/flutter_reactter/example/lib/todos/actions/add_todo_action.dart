import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/todo.dart';
import '../stores/todos_store.dart';

class AddTodoAction extends ReactterActionCallable<TodosStore, Todo> {
  final Todo todo;

  const AddTodoAction({
    required this.todo,
  }) : super(
          type: 'ADD_TODO',
          payload: todo,
        );

  @override
  TodosStore call(TodosStore state) {
    return state.copyWith(
      todos: [todo, ...state.todos],
    );
  }
}
