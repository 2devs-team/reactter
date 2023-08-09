import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import '../actions/add_todo_action.dart';
import '../actions/filter_action.dart';
import '../actions/remove_todo_action.dart';
import '../actions/toggle_todo_action.dart';
import '../models/todo.dart';
import '../stores/todos_store.dart';

TodosStore _reducer(TodosStore state, ReactterAction action) =>
    action is ReactterActionCallable ? action(state) : UnimplementedError();

class TodosController {
  final formKey = GlobalKey<FormState>();
  final textFocusNode = FocusNode();
  final textController = TextEditingController();

  final state = UseReducer<TodosStore>(
    _reducer,
    const TodosStore(
      todos: [
        Todo(title: 'Learn Reactter'),
      ],
    ),
  );

  late final todosFiltered = Reactter.lazy(
    () => UseCompute(
      () => getTodosBy(state.value.filterBy),
      [state],
    ),
    this,
  );

  List<Todo> getTodosBy(TodoListType todoListType) {
    if (todoListType == TodoListType.todo) {
      return state.value.todos.where((todo) => !todo.isDone).toList();
    }

    if (todoListType == TodoListType.done) {
      return state.value.todos.where((todo) => todo.isDone).toList();
    }

    return state.value.todos;
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Can't be empty";
    }

    if (value.length < 4) {
      return "Must be at least 4 characters";
    }

    return null;
  }

  void addTodo() {
    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) return;

    state.dispatch(AddTodoAction(todo: Todo(title: textController.text)));
    _resetForm();
  }

  void removeTodo(Todo todo) {
    state.dispatch(RemoveTodoAction(todo: todo));
  }

  void toggleTodo(Todo todo) {
    state.dispatch(ToggleTodoAction(todo: todo));
  }

  void filterBy(TodoListType todoListType) {
    state.dispatch(FilterAction(todoListType: todoListType));
  }

  void _resetForm() {
    formKey.currentState?.reset();
    textFocusNode.requestFocus();
  }
}
