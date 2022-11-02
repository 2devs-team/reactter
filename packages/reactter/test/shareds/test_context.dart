import 'package:reactter/reactter.dart';

class TestClass {
  final String prop;

  TestClass(this.prop);
}

class TestStore {
  final int count;

  TestStore({this.count = 0});
}

class IncrementAction extends ReactterAction<String, int> {
  IncrementAction({int quantity = 1})
      : super(type: 'INCREMENT', payload: quantity);
}

class DecrementAction extends ReactterAction<String, int> {
  DecrementAction({int quantity = 1})
      : super(type: 'DECREMENT', payload: quantity);
}

class IncrementActionCallable extends ReactterActionCallable<TestStore, int> {
  IncrementActionCallable({int quantity = 1})
      : super(type: 'INCREMENT', payload: quantity);

  @override
  TestStore call(TestStore state) {
    return TestStore(count: state.count + payload);
  }
}

class DecrementActionCallable extends ReactterActionCallable<TestStore, int> {
  DecrementActionCallable({int quantity = 1})
      : super(type: 'DECREMENT', payload: quantity);

  @override
  TestStore call(TestStore state) {
    return TestStore(count: state.count - payload);
  }
}

class TestContext extends ReactterContext {
  final signalString = "initial".signal;

  final stateBool = UseState(false);
  late final stateString = UseState("initial");
  late final stateInt = UseState(0, this);
  late final stateDouble = UseState(0.0, this);
  late final stateList = UseState([], this);
  late final stateMap = UseState({}, this);
  late final stateClass = UseState<TestClass?>(null, this);
  late final stateAsync = UseAsyncState("initial", _resolveStateAsync, this);
  late final stateReduce = UseReducer(_reducer, TestStore(count: 0), this);

  TestContext() {
    listenHooks([stateBool, stateString]);
  }

  Future<String> _resolveStateAsync([bool throwError = false]) async {
    if (throwError) {
      throw Exception("has a error");
    }

    await Future.delayed(const Duration(microseconds: 1));

    return "resolved";
  }

  TestStore _reducer(TestStore state, ReactterAction action) {
    if (action is ReactterActionCallable) {
      return action(state);
    }

    switch (action.type) {
      case 'INCREMENT':
        return TestStore(
          count: state.count + (action.payload as int),
        );
      case 'DECREMENT':
        return TestStore(
          count: state.count - (action.payload as int),
        );
      default:
        throw UnimplementedError();
    }
  }
}

class Test2Context extends ReactterContext {
  late final testContext = UseContext<TestContext>(context: this);

  Test2Context() {
    Reactter.create(builder: () => TestContext());
  }
}
