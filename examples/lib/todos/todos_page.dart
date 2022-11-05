import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'todo_item.dart';
import 'todos_context.dart';
import 'todos_store.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReactterProvider<TodosContext>(
        () => TodosContext(),
        builder: (todosCtx, context, _) {
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
                                key: todosCtx.formKey,
                                child: TextFormField(
                                  controller: todosCtx.textController,
                                  validator: todosCtx.validator,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  autofocus: true,
                                  focusNode: todosCtx.textFocusNode,
                                  maxLength: 50,
                                  onFieldSubmitted: (_) => todosCtx.addTodo(),
                                  decoration: const InputDecoration(
                                    labelText: 'What needs to be done?',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                              onPressed: todosCtx.addTodo,
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
                        const SizedBox(
                          height: 16,
                        ),
                        Builder(
                          builder: (context) {
                            context.watch<TodosContext>((ctx) => [ctx.state]);

                            return TabBar(
                              onTap: (index) => todosCtx.filterBy(index),
                              tabs: [
                                Tab(
                                  text:
                                      "All(${todosCtx.state.value.todos.length})",
                                ),
                                Tab(
                                  text:
                                      "Done(${todosCtx.getTodosBy(TodoListType.done).length})",
                                ),
                                Tab(
                                  text:
                                      "Pending(${todosCtx.getTodosBy(TodoListType.pending).length})",
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
                        context.watch<TodosContext>((ctx) => [ctx.state]);

                        final todoList = todosCtx.todosFiltered;

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
