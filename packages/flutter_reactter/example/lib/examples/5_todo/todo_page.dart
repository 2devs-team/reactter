import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/controllers/todo_controller.dart';
import 'package:examples/examples/5_todo/widgets/input_bar.dart';
import 'package:examples/examples/5_todo/widgets/todo_filter.dart';
import 'package:examples/examples/5_todo/widgets/todo_list.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtProvider(
      TodoController.new,
      builder: (context, todoController, _) {
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
                        InputBar(onAdd: todoController.addTodo),
                        const SizedBox(height: 4),
                        const TodoFilter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: const TodoList(),
        );
      },
    );
  }
}
