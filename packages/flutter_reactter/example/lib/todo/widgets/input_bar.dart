import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  const InputBar({
    super.key,
    this.onAdd,
  });

  final void Function(String task)? onAdd;

  @override
  Widget build(BuildContext context) {
    final inputKey = GlobalKey<FormFieldState<String>>();
    final focusNode = FocusNode();

    void add() {
      final isValid = inputKey.currentState?.validate() ?? false;

      if (!isValid) return;

      final task = inputKey.currentState?.value ?? '';

      onAdd?.call(task);
      inputKey.currentState?.reset();
    }

    String? validator(String? value) {
      if (value == null || value.isEmpty) {
        return "Can't be empty";
      }

      if (value.length < 4) {
        return "Must be at least 4 characters";
      }

      return null;
    }

    return TextFormField(
      key: inputKey,
      maxLength: 150,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: (_) {
        focusNode.requestFocus();
        add();
      },
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        hintText: 'What needs to be done?',
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          gapPadding: 0,
        ),
        counter: const SizedBox(),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 4,
          ).copyWith(left: 0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              side: BorderSide(
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Theme.of(context).colorScheme.primary,
                width: 0.5,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(1.5),
                ),
              ),
            ),
            onPressed: add,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
