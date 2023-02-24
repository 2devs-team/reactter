import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'todos_context.dart';
import 'todo_entity.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Color? color;

  const TodoItem({
    Key? key,
    required this.todo,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterScope(
      builder: (context, child) {
        final ctx = context.use<TodosContext>();
        return CheckboxListTile(
          value: todo.isDone,
          onChanged: (_) => ctx.toggleTodo(todo),
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(
            todo.title,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                ),
          ),
          secondary: IconButton(
            onPressed: () => ctx.removeTodo(todo),
            color: Colors.red.shade400,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 42),
            splashRadius: 18,
            iconSize: 24,
            icon: const Icon(Icons.close_outlined),
          ),
        );
      },
    );
  }
}
