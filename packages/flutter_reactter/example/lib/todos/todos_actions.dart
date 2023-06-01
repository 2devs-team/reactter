import 'package:flutter_reactter/flutter_reactter.dart';

import 'todo_entity.dart';
import 'todos_store.dart';

class AddTodoAction extends ReactterActionCallable<TodosStore, Todo> {
  final Todo todo;

  AddTodoAction({
    required this.todo,
  }) : super(
          type: 'ADD_TODO',
          payload: todo,
        );

  @override
  TodosStore call(TodosStore state) {
    return state.copyWith(
      todos: state.todos..add(todo),
    );
  }
}

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

class FilterByAction extends ReactterActionCallable<TodosStore, TodoListType> {
  final TodoListType todoListType;

  FilterByAction({
    required this.todoListType,
  }) : super(
          type: 'FILTER_BY',
          payload: todoListType,
        );

  @override
  TodosStore call(TodosStore state) {
    return state.copyWith(filterBy: todoListType);
  }
}
