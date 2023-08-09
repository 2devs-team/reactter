import '../models/todo.dart';

enum TodoListType { all, done, todo }

class TodosStore {
  final List<Todo> todos;
  final TodoListType filterBy;

  const TodosStore({
    required this.todos,
    this.filterBy = TodoListType.all,
  });

  TodosStore copyWith({
    List<Todo>? todos,
    TodoListType? filterBy,
  }) =>
      TodosStore(
        todos: todos ?? this.todos,
        filterBy: filterBy ?? this.filterBy,
      );
}
