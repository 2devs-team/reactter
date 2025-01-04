import 'package:flutter/material.dart';

import 'package:examples/examples/5_todo/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final void Function()? onTap;
  final void Function()? onRemove;

  const TodoItem({
    Key? key,
    required this.todo,
    this.onTap,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: todo.isDone,
      onChanged: (_) => onTap?.call(),
      dense: true,
      visualDensity: VisualDensity.compact,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        todo.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
            ),
      ),
      secondary: IconButton(
        onPressed: onRemove,
        color: Colors.red.shade400,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 24),
        splashRadius: 18,
        iconSize: 24,
        icon: const Icon(Icons.close_outlined),
      ),
    );
  }
}
