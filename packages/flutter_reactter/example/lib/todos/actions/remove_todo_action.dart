import 'package:flutter_reactter/flutter_reactter.dart';

import '../models/todo.dart';
import '../stores/todos_store.dart';

class RemoveTodoAction extends ReactterActionCallable<TodosStore, Todo> {
  final Todo todo;

  RemoveTodoAction({
    required this.todo,
  }) : super(
          type: 'REMOVE_TODO',
          payload: todo,
        );

  @override
  TodosStore call(TodosStore state) {
    return state.copyWith(todos: state.todos..remove(todo));
  }
}
