import 'package:flutter/material.dart';
import 'package:reactter/reactter.dart';

import 'todo_context.dart';

enum TodoListType { all, active, completed }

class TodosContext extends ReactterContext {
  final formKey = GlobalKey<FormState>();
  final textFocusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  late final todos = UseState(<TodoContext>[], this);
  late final todoList = UseState(<TodoContext>[], this);
  late final todoListType = UseState(TodoListType.all, this);

  String _input = "";

  TodosContext() {
    textController.addListener(() {
      _input = textController.text;
    });

    UseEffect(_useEffectTodos, [todos, todoListType], this);
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
    if (!formKey.currentState!.validate()) {
      return;
    }

    final todoContext = TodoContext(title: _input);

    todos.update(() => todos.value.add(todoContext));

    UseEvent.withInstance(todoContext).on(
      Lifecycle.didUpdate,
      (_, __) => _didUpdateTodo(todoContext),
    );

    formKey.currentState!.reset();
    textFocusNode.requestFocus();
  }

  void showTodosByType(TodoListType type) => todoListType.value = type;

  void _didUpdateTodo(TodoContext todo) {
    if (todoListType.value == TodoListType.all) {
      return;
    }

    final filterCompleted = todoListType.value == TodoListType.completed;

    if (todo.completed.value == !filterCompleted) {
      todos.update();
    }
  }

  void _useEffectTodos() {
    List<TodoContext> todosFiltered = [];

    if (todoListType.value == TodoListType.all) {
      todosFiltered = todos.value.toList();
    } else {
      final filterCompleted = todoListType.value == TodoListType.completed;

      todosFiltered = todos.value.where((todo) {
        return todo.completed.value == filterCompleted;
      }).toList();
    }

    if (todosFiltered.length == todos.value.length &&
        todosFiltered.length == todoList.value.length) {
      return;
    }

    todoList.value = todosFiltered;
  }
}
