import 'package:flutter_reactter/flutter_reactter.dart';

class TestClass {
  final String prop;

  TestClass(this.prop);
}

Future<String> _resolveStateAsync([bool throwError = false]) async {
  if (throwError) {
    throw Exception("has a error");
  }

  await Future.delayed(const Duration(microseconds: 1));

  return "resolved";
}

class TestController {
  final signalString = "initial".signal;
  final signalInt = 0.signal;

  final stateBool = UseState(false);
  final stateString = UseState("initial");
  final stateInt = UseState(0);
  final stateDouble = UseState(0.0);
  final stateList = UseState([]);
  final stateMap = UseState({});
  final stateClass = UseState<TestClass?>(null);
  final stateAsync = UseAsyncState("initial", _resolveStateAsync);
}
