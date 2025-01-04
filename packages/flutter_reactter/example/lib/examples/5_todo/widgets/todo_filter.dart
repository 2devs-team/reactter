import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/controllers/todo_controller.dart';
import 'package:examples/examples/5_todo/stores/todo_store.dart';
import 'package:examples/examples/5_todo/widgets/radio_with_label.dart';

class TodoFilter extends StatelessWidget {
  const TodoFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RtSelector<TodoController, TodoListType>(
            selector: (inst, watch) => watch(inst.uReduce).value.filteredBy,
            builder: (_, __, filteredBy, ___) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text('Filter by:'),
                  const SizedBox(width: 4),
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
                      return Row(
                        children: [
                          RadioWithLabel(
                            label: 'Completed($doneCount)',
                            value: TodoListType.done,
                            groupValue: filteredBy,
                            onChanged: todoController.filterBy,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Clear completed',
                            color: Colors.red.shade400,
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints.tightFor(width: 24),
                            splashRadius: 18,
                            iconSize: 24,
                            icon: const Icon(Icons.delete),
                            onPressed: doneCount > 0
                                ? todoController.clearCompleted
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
