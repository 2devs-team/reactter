import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/stores/todo_store.dart';

class ClearCompletedAction extends RtActionCallable<TodoStore, void> {
  const ClearCompletedAction()
      : super(
          type: 'ADD_TODO',
          payload: null,
        );

  @override
  TodoStore call(TodoStore state) {
    return state.copyWith(
      todoList: [
        for (final todo in state.todoList)
          if (!todo.isDone) todo
      ],
      doneCount: 0,
    );
  }
}
