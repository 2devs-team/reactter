import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'todo_context.dart';

class TodoItem extends ReactterComponent<TodoContext> {
  const TodoItem({
    Key? key,
    required this.todo,
    this.color,
  }) : super(key: key);

  final TodoContext todo;
  final Color? color;

  @override
  get id => todo.hashCode.toString();

  @override
  get builder => () => todo;

  @override
  Widget render(ctx, context) {
    return ListTile(
      onTap: () => (ctx.completed.value = !ctx.completed.value),
      tileColor: color,
      dense: true,
      title: Text(
        todo.title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              decoration:
                  ctx.completed.value ? TextDecoration.lineThrough : null,
            ),
      ),
      subtitle: Text(
        "id: $id",
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
