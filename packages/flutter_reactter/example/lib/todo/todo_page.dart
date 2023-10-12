import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'controllers/todo_controller.dart';
import 'stores/todo_store.dart';
import 'widgets/input_bar.dart';
import 'widgets/radio_with_label.dart';
import 'widgets/todo_item.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider<TodoController>(
      () => TodoController(),
      builder: (todoController, context, _) {
        final size = MediaQuery.of(context).size;

        return Scaffold(
          appBar: AppBar(
            title: const Text("To-Do List"),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.width >= 480 ? 82 : 110),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InputBar(
                          onAdd: todoController.addTodo,
                        ),
                        ReactterConsumer<TodoController>(
                          listenStates: (inst) => [
                            ...[inst.state].when(
                              () => inst.state.value.filterBy,
                              () => inst.state.value.todoList.length,
                            ),
                            inst.todoActiveCount,
                          ],
                          builder: (todoController, _, __) {
                            final state = todoController.state;
                            final filterBy = state.value.filterBy;
                            final allCount = state.value.todoList.length;
                            final activeCount =
                                todoController.todoActiveCount.value;
                            final completedCount = allCount - activeCount;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FittedBox(
                                    child: SizedBox(
                                      height: 30,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Filter by:'),
                                          RadioWithLabel(
                                            label: 'All($allCount)',
                                            value: TodoListType.all,
                                            groupValue: filterBy,
                                            onChanged: todoController.filterBy,
                                          ),
                                          RadioWithLabel(
                                            label: 'Active($activeCount)',
                                            value: TodoListType.todo,
                                            groupValue: filterBy,
                                            onChanged: todoController.filterBy,
                                          ),
                                          RadioWithLabel(
                                            label: 'Completed($completedCount)',
                                            value: TodoListType.done,
                                            groupValue: filterBy,
                                            onChanged: todoController.filterBy,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    onPressed: completedCount > 0
                                        ? todoController.clearCompleted
                                        : null,
                                    child: const Text('Clear completed'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: ReactterConsumer<TodoController>(
            listenStates: (inst) => [inst.todoListFiltered],
            builder: (todoController, _, __) {
              final todoListFiltered = todoController.todoListFiltered.value;

              return ListView.builder(
                itemCount: todoListFiltered.length,
                itemBuilder: (context, index) {
                  final todo = todoListFiltered[index];

                  return TodoItem(
                    key: ObjectKey(todo),
                    todo: todo,
                    onTap: () => todoController.toggleTodo(todo),
                    onRemove: () => todoController.removeTodo(todo),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
