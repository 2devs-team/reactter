import 'package:flutter_reactter/flutter_reactter.dart';

import '../stores/todos_store.dart';

class FilterAction extends ReactterActionCallable<TodosStore, TodoListType> {
  final TodoListType todoListType;

  const FilterAction({
    required this.todoListType,
  }) : super(
          type: 'FILTER_BY',
          payload: todoListType,
        );

  @override
  TodosStore call(TodosStore state) {
    return state.copyWith(filterBy: todoListType);
  }
}
