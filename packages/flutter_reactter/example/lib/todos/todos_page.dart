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
                                  controller: todosController.textController,
                                  validator: todosController.validator,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autofocus: true,
                                  focusNode: todosController.textFocusNode,
                                  maxLength: 50,
                                  onFieldSubmitted: (_) =>
                                      todosController.addTodo(),
                                  decoration: const InputDecoration(
                                    labelText: 'What needs to be done?',
                                  ),
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
                                      .headline6!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            context
                                .watch<TodosController>((inst) => [inst.state]);

                            return TabBar(
                              labelColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              onTap: (index) => todosController.filterBy(index),
                              tabs: [
                                Tab(
                                  text:
                                      "All(${todosController.state.value.todos.length})",
                                ),
                                Tab(
                                  text:
                                      "Done(${todosController.getTodosBy(TodoListType.done).length})",
                                ),
                                Tab(
                                  text:
                                      "To-Do(${todosController.getTodosBy(TodoListType.todo).length})",
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final todoList = context
                            .watch<TodosController>((inst) => [inst.state])
                            .todosFiltered;

                        return SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: todoList.length,
                            itemBuilder: (context, index) {
                              final todo = todoList[index];

                              return TodoItem(
                                key: ObjectKey(todo),
                                todo: todo,
                                color: index % 2 == 0
                                    ? Theme.of(context).hoverColor
                                    : Theme.of(context).cardColor,
                              );
                            },
                          ),
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
