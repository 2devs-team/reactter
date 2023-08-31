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

Future<String> _resolveStateAsync(Arg<bool> args) async {
  final throwError = args.arg;

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

class TestController with ReactterState {
  final signalString = "initial".signal;

  late final stateBool = UseState(false);
  final stateString = UseState("initial");
  final stateInt = UseState(0);
  final stateDouble = UseState(0.0);
  final stateList = UseState([]);
  final stateMap = UseState({});
  final stateClass = UseState<TestClass?>(null);
  final stateAsync = UseAsyncState.withArg("initial", _resolveStateAsync);
  final stateReduce = UseReducer(_reducer, TestStore(count: 0));

  late final stateCompute = Reactter.lazy(
    () => UseCompute(
      () => (stateInt.value + stateDouble.value).clamp(5, 10),
      [stateInt, stateDouble],
    ),
    this,
  );
}

class Test2Controller {
  final testController = UseContext<TestController>();

  Test2Controller() {
    Reactter.create(builder: () => TestController());
  }
}

class Test3Controller {
  final test2Controller = UseContext<Test2Controller>();

  Test3Controller() {
    Reactter.create(builder: () => Test2Controller());
  }
}

final test3Controller = UseContext<Test3Controller>();
