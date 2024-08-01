import 'package:reactter/reactter.dart';
import 'package:flutter/widgets.dart';

class UseTextInput extends RtHook {
  // This line is REQUIRED!
  final $ = RtHook.$register;

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
