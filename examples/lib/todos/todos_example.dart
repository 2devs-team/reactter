import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'todo_item.dart';
import 'todos_context.dart';

class TodosExamples extends StatelessWidget {
  const TodosExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactterProvider(
      () => TodosContext(),
      builder: (context, _) {
        final todosCtx = context.use<TodosContext>();

        return Scaffold(
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Form(
                            key: todosCtx.formKey,
                            child: TextFormField(
                              controller: todosCtx.textController,
                              validator: todosCtx.validator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textCapitalization: TextCapitalization.sentences,
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
                          child: Text(
                            "Add todo",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    ReactterBuilder<TodosContext>(
                      listenHooks: (ctx) => [ctx.todoListType],
                      builder: (todosCtx, context, _) {
                        final todoListType = todosCtx.todoListType.value;

                        return Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          children: [
                            const Text("Show:"),
                            ElevatedButton(
                              onPressed: todoListType == TodoListType.all
                                  ? null
                                  : () => todosCtx
                                      .showTodosByType(TodoListType.all),
                              child: const Text("All"),
                            ),
                            ElevatedButton(
                              onPressed: todoListType == TodoListType.active
                                  ? null
                                  : () => todosCtx
                                      .showTodosByType(TodoListType.active),
                              child: const Text("Active"),
                            ),
                            ElevatedButton(
                              onPressed: todoListType == TodoListType.completed
                                  ? null
                                  : () => todosCtx
                                      .showTodosByType(TodoListType.completed),
                              child: const Text("Completed"),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReactterBuilder<TodosContext>(
                  listenHooks: (ctx) => [ctx.todoList],
                  builder: (todosCtx, context, _) {
                    final todoList = todosCtx.todoList.value;

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
        );
      },
    );
  }
}
