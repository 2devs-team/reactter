import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/controllers/todo_controller.dart';
import 'package:examples/examples/5_todo/widgets/todo_item.dart';

class TodoList extends RtComponent<TodoController> {
  const TodoList({super.key});

  @override
  ListenStates<TodoController>? get listenStates => (inst) => [inst.uReduce];

  @override
  Widget render(BuildContext context, TodoController inst) {
    final todos = inst.getTodosBy(inst.uReduce.value.filteredBy);

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];

        return TodoItem(
          key: ObjectKey(todo),
          todo: todo,
          onTap: () => inst.toggleTodo(todo),
          onRemove: () => inst.removeTodo(todo),
        );
      },
    );
  }
}
