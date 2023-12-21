import '../models/todo.dart';

enum TodoListType { all, done, todo }

class TodoStore {
  final List<Todo> todoList;
  final TodoListType filteredBy;
  final int doneCount;

  const TodoStore({
    required this.todoList,
    this.filteredBy = TodoListType.all,
    this.doneCount = 0,
  });

  TodoStore copyWith({
    List<Todo>? todoList,
    TodoListType? filteredBy,
    int? doneCount,
  }) =>
      TodoStore(
        todoList: todoList ?? this.todoList,
        filteredBy: filteredBy ?? this.filteredBy,
        doneCount: doneCount ?? this.doneCount,
      );
}
