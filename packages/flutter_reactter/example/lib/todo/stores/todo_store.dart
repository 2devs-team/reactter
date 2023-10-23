import '../models/todo.dart';

enum TodoListType { all, done, todo }

class TodoStore {
  final List<Todo> todoList;
  final TodoListType filterBy;

  const TodoStore({
    required this.todoList,
    this.filterBy = TodoListType.all,
  });

  TodoStore copyWith({
    List<Todo>? todoList,
    TodoListType? filterBy,
  }) =>
      TodoStore(
        todoList: todoList ?? this.todoList,
        filterBy: filterBy ?? this.filterBy,
      );
}
