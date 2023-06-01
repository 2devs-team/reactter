import 'package:reactter/reactter.dart';

class TestClass {
  final String prop;

  TestClass(this.prop);
}

class TestStore {
  final int count;

  TestStore({this.count = 0});
}

class IncrementAction extends ReactterAction<int> {
  IncrementAction({int quantity = 1})
      : super(type: 'INCREMENT', payload: quantity);
}

class DecrementAction extends ReactterAction<int> {
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

final stateExt = UseState(null);

class TestController with ReactterNotifyManager {
  final signalString = "initial".signal;

  final stateBool = UseState(false);
  final stateString = UseState("initial");
  final stateInt = UseState(0);
  final stateDouble = UseState(0.0);
  final stateList = UseState([]);
  final stateMap = UseState({});
  final stateClass = UseState<TestClass?>(null);
  late final stateAsync = UseAsyncState("initial", _resolveStateAsync);
  late final stateReduce = UseReducer(_reducer, TestStore(count: 0));

  TestController() {
    stateExt.attachTo(this); // for coverage
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

final testControllerExt = UseContext<TestController>();

class Test2Controller {
  final testController = UseContext<TestController>();

  Test2Controller() {
    testControllerExt.attachTo(this); // for coverage
    Reactter.create(builder: () => TestController());
  }
}

class Test3Controller {
  final test2Controller = UseContext<Test2Controller>();

  Test3Controller() {
    testControllerExt.attachTo(this); // for coverage
    Reactter.create(builder: () => Test2Controller());
  }
}
