import 'package:flutter_reactter/flutter_reactter.dart';

class TodoContext extends ReactterContext {
  final String title;

  late final completed = UseState(false, this);

  TodoContext({
    required this.title,
    bool completed = false,
  }) {
    this.completed.value = completed;
  }
}
