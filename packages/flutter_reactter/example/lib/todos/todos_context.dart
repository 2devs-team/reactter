import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'todos_actions.dart';
import 'todo_entity.dart';
import 'todos_store.dart';

TodosStore _reducer(TodosStore state, ReactterAction action) =>
    action is ReactterActionCallable ? action(state) : UnimplementedError();

class TodosContext extends ReactterContext {
  final formKey = GlobalKey<FormState>();
  final textFocusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  late final state = UseReducer<TodosStore>(
    _reducer,
    TodosStore(todos: [Todo(title: 'Learn Reactter')]),
  );

  List<Todo> get todosFiltered => getTodosBy(state.value.filterBy);

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Can't be empty";
    }

    if (value.length < 4) {
      return "Must be at least 4 characters";
    }

    return null;
  }

  List<Todo> getTodosBy(TodoListType todoListType) {
    if (todoListType == TodoListType.todo) {
      return state.value.todos.where((todo) => !todo.isDone).toList();
    }

    if (todoListType == TodoListType.done) {
      return state.value.todos.where((todo) => todo.isDone).toList();
    }

    return state.value.todos;
  }

  void addTodo() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    state.dispatch(AddTodoAction(todo: Todo(title: textController.text)));

    _resetForm();
  }

  void removeTodo(Todo todo) => state.dispatch(RemoveTodoAction(todo: todo));

  void toggleTodo(Todo todo) => state.dispatch(ToggleTodoAction(todo: todo));

  void filterBy(int index) =>
      state.dispatch(FilterByAction(todoListType: TodoListType.values[index]));

  void _resetForm() {
    formKey.currentState?.reset();
    textFocusNode.requestFocus();
  }
}