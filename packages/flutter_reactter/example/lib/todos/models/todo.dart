class Todo {
  final String title;
  final bool isDone;

  const Todo({
    required this.title,
    this.isDone = false,
  });

  Todo copyWith({
    String? title,
    bool? isDone,
  }) =>
      Todo(
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );
}
