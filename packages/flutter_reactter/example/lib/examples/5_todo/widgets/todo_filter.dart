import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/controllers/todo_controller.dart';
import 'package:examples/examples/5_todo/stores/todo_store.dart';
import 'package:examples/examples/5_todo/widgets/radio_with_label.dart';

class TodoFilter extends StatelessWidget {
  const TodoFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FittedBox(
          child: SizedBox(
            height: 30,
            child: RtSelector<TodoController, TodoListType>(
              selector: (inst, watch) => watch(inst.uReduce).value.filteredBy,
              builder: (_, __, filteredBy, ___) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Filter by:'),
                    RtSelector<TodoController, int>(
                      selector: (inst, watch) {
                        return watch(inst.uReduce).value.todoList.length;
                      },
                      builder: (_, todoController, allCount, __) {
                        return RadioWithLabel(
                          label: 'All($allCount)',
                          value: TodoListType.all,
                          groupValue: filteredBy,
                          onChanged: todoController.filterBy,
                        );
                      },
                    ),
                    RtSelector<TodoController, int>(
                      selector: (inst, watch) {
                        final uReduce = watch(inst.uReduce).value;
                        final allCount = uReduce.todoList.length;
                        final doneCount = uReduce.doneCount;

                        return allCount - doneCount;
                      },
                      builder: (_, todoController, activeCount, __) {
                        return RadioWithLabel(
                          label: 'Active($activeCount)',
                          value: TodoListType.todo,
                          groupValue: filteredBy,
                          onChanged: todoController.filterBy,
                        );
                      },
                    ),
                    RtSelector<TodoController, int>(
                      selector: (inst, watch) {
                        return watch(inst.uReduce).value.doneCount;
                      },
                      builder: (_, todoController, doneCount, __) {
                        return RadioWithLabel(
                          label: 'Completed($doneCount)',
                          value: TodoListType.done,
                          groupValue: filteredBy,
                          onChanged: todoController.filterBy,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        RtSelector<TodoController, bool>(
          selector: (inst, watch) {
            return watch(inst.uReduce).value.doneCount > 0;
          },
          builder: (_, todoController, hasCount, __) {
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: hasCount ? todoController.clearCompleted : null,
              child: const Text('Clear completed'),
            );
          },
        ),
      ],
    );
  }
}
