import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.onSearch,
  });

  final void Function(String query)? onSearch;

  @override
  Widget build(BuildContext context) {
    final searchKey = GlobalKey<FormFieldState<String>>();
    final focusNode = FocusNode();

    void search() {
      final isValid = searchKey.currentState?.validate() ?? false;

      if (!isValid) return;

      final query = searchKey.currentState?.value ?? '';

      onSearch?.call(query);
    }

    String? validator(String? value) {
      if (value == null || value.isEmpty) {
        return "Can't be empty";
      }

      return null;
    }

    return TextFormField(
      key: searchKey,
      maxLength: 150,
      autofocus: true,
      scrollPadding: EdgeInsets.zero,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        focusNode.requestFocus();
        search();
      },
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        hintText: 'Type a username or repository (like "flutter/flutter")',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        counter: const SizedBox(),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 4,
          ).copyWith(left: 0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              side: BorderSide(
                strokeAlign: BorderSide.strokeAlignOutside,
                width: 0.5,
                color: Theme.of(context).colorScheme.primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text('Search'),
            onPressed: () => search(),
          ),
        ),
      ),
    );
  }
}
