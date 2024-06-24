import 'package:reactter/reactter.dart';
import 'package:flutter/widgets.dart';

class UseTextInput extends ReactterHook {
  // This line is REQUIRED!
  final $ = ReactterHook.$register;

  final controller = TextEditingController();

  String _value = '';
  String? get value => _value;

  UseTextInput() {
    UseEffect(() {
      controller.addListener(() {
        update(() => _value = controller.text);
      });

      return controller.dispose;
    }, []);
  }
}
