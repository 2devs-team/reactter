import 'package:flutter/widgets.dart';

class SearchInputController {
  final void Function(String query) onSearch;

  SearchInputController({required this.onSearch});

  final searchKey = GlobalKey<FormFieldState<String>>();
  final focusNode = FocusNode();

  String? validator(String? value) {
    if ((value?.isEmpty ?? true)) {
      return "Can't be empty";
    }

    return null;
  }

  void onFieldSubmitted(String query) {
    if (!(searchKey.currentState?.validate() ?? false)) return;

    onSearch.call(query);
  }

  void onButtonPressed() {
    final query = searchKey.currentState?.value ?? '';
    onFieldSubmitted(query);
  }
}
