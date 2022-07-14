import 'package:flutter_reactter/flutter_reactter.dart';

class TestClass {
  final String prop;

  TestClass(this.prop);
}

class TestContext extends ReactterContext {
  late final stateBool = UseState(false, this);
  late final stateString = UseState("initial", this);
  late final stateInt = UseState(0, this);
  late final stateDouble = UseState(0.0, this);
  late final stateList = UseState([], this);
  late final stateMap = UseState({}, this);
  late final stateClass = UseState<TestClass?>(null, this);

  late final stateAsync = UseAsyncState("initial", _resolveStateAsync, this);

  Future<String> _resolveStateAsync([bool throwError = false]) async {
    if (throwError) {
      throw Exception("has a error");
    }

    await Future.delayed(const Duration(microseconds: 1));

    return "resolved";
  }
}
