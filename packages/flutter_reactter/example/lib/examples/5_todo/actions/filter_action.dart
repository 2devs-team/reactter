import 'package:flutter_reactter/flutter_reactter.dart';

import 'package:examples/examples/5_todo/stores/todo_store.dart';

class FilterAction extends RtActionCallable<TodoStore, TodoListType> {
  final TodoListType todoListType;

  const FilterAction({
    required this.todoListType,
  }) : super(
          type: 'FILTER_BY',
          payload: todoListType,
        );

  @override
  TodoStore call(TodoStore state) {
    return state.copyWith(filteredBy: todoListType);
  }
}
