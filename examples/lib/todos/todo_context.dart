import 'package:reactter/reactter.dart';

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
