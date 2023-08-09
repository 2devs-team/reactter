import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'widgets/todo_item.dart';
import 'controllers/todos_controller.dart';
import 'stores/todos_store.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReactterProvider<TodosController>(
        () => TodosController(),
        builder: (todosController, context, _) {
          return DefaultTabController(
            length: TodoListType.values.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Todos"),
              ),
              body: Column(
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Form(
                                key: todosController.formKey,
                                child: TextFormField(
                                  autofocus: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    labelText: 'What needs to be done?',
                                  ),
                                  maxLength: 50,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: todosController.textController,
                                  focusNode: todosController.textFocusNode,
                                  validator: todosController.validator,
                                  onFieldSubmitted: (_) =>
                                      todosController.addTodo(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: todosController.addTodo,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Add",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ReactterConsumer<TodosController>(
                          listenStates: (inst) => [inst.state],
                          builder: (_, __, ___) {
                            final allCount = todosController
                                .getTodosBy(TodoListType.all)
                                .length;
                            final doneCount = todosController
                                .getTodosBy(TodoListType.done)
                                .length;
                            final todoCount = todosController
                                .getTodosBy(TodoListType.todo)
                                .length;

                            return TabBar(
                              labelColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              tabs: [
                                Tab(text: "All($allCount)"),
                                Tab(text: "Done($doneCount)"),
                                Tab(text: "To-Do($todoCount)"),
                              ],
                              onTap: (index) {
                                todosController.filterBy(
                                  TodoListType.values[index],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ReactterConsumer<TodosController>(
                      listenStates: (inst) => [inst.todosFiltered],
                      builder: (todosController, _, __) {
                        final todosFiltered =
                            todosController.todosFiltered.value;

                        return ListView.builder(
                          itemCount: todosFiltered.length,
                          itemBuilder: (context, index) {
                            final todo = todosFiltered[index];

                            return TodoItem(
                              key: ObjectKey(todo),
                              todo: todo,
                              color: index % 2 == 0
                                  ? Theme.of(context).hoverColor
                                  : Theme.of(context).cardColor,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
