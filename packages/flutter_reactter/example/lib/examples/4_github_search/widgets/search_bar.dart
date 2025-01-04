import 'package:examples/examples/4_github_search/controllers/search_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

class SearchBar extends StatelessWidget {
  final void Function(String query) onSearch;

  const SearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return RtProvider(
      () => SearchInputController(onSearch: onSearch),
      builder: (context, searchInputController, child) {
        return TextFormField(
          key: searchInputController.searchKey,
          maxLength: 150,
          autofocus: true,
          scrollPadding: EdgeInsets.zero,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: searchInputController.validator,
          focusNode: searchInputController.focusNode,
          onFieldSubmitted: searchInputController.onFieldSubmitted,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            hintText: 'Type a username or repository (like "flutter/flutter")',
            border: const OutlineInputBorder(),
            counter: const SizedBox(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(4),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                  side: BorderSide(
                    strokeAlign: BorderSide.strokeAlignOutside,
                    width: 0.5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onPressed: searchInputController.onButtonPressed,
                child: const Text('Search'),
              ),
            ),
          ),
        );
      },
    );
  }
}
