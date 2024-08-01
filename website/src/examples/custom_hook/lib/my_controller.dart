import 'package:flutter_reactter/flutter_reactter.dart';
import 'use_text_input.dart';

class MyController {
  final firstNameInput = UseTextInput();
  final lastNameInput = UseTextInput();

  late final fullName = Rt.lazyState(
    () => UseCompute(
      () {
        final firstName = firstNameInput.value;
        final lastName = lastNameInput.value;

        return "$firstName $lastName";
      },
      [firstNameInput, lastNameInput],
    ),
    this,
  );
}
