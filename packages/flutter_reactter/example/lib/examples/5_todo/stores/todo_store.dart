import 'package:examples/examples/5_todo/models/todo.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'todoList': todoList.map((e) => e.toJson()).toList(),
      'filteredBy': filteredBy.toString(),
      'doneCount': doneCount,
    };
  }
}
