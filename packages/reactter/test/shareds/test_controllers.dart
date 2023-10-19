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

Future<String> _resolveStateAsync([
  Args args = const Args1(null),
]) async {
  if (args.arguments.any((arg) => arg is! String && arg != null)) {
    throw Exception("has a error");
  }

  final argsString = args.toList<String>().join(',');

  await Future.delayed(const Duration(microseconds: 1));

  return argsString.isEmpty ? "resolved" : "resolved with args: $argsString";
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

class TestController extends ReactterStateImpl {
  final signalString = "initial".signal;

  late final stateBool = UseState(false);
  final stateString = UseState("initial");
  final stateInt = UseState(0);
  final stateDouble = UseState(0.0);
  final stateList = UseState([]);
  final stateMap = UseState({});
  final stateClass = UseState<TestClass?>(null);
  final stateAsync = UseAsyncState("initial", _resolveStateAsync);
  final stateAsyncWithArg = UseAsyncState.withArgs(
    "initial",
    _resolveStateAsync,
  );
  final stateAsyncWithError = UseAsyncState("initial", () {
    throw Exception("has a error");
  });
  final stateReduce = UseReducer(_reducer, TestStore(count: 0));

  late final stateCompute = Reactter.lazyState(
    () => UseCompute(
      () => (stateInt.value + stateDouble.value).clamp(5, 10),
      [stateInt, stateDouble],
    ),
    this,
  );

  final memo = Memo((Args? args) {
    if (args is Args1<Future>) return args.arg1;

    if (args is Args1<Error>) {
      throw args.arg1;
    }

    return args?.arguments ?? [];
  });

  final asyncMemo = Memo(
    (Args? args) {
      if (args is Args1<Future>) return args.arg1;

      if (args is Args1<Error>) {
        throw args.arg1;
      }

      return args?.arguments ?? [];
    },
    AsyncMemoSafe(),
  );

  final inlineMemo = Memo.inline((Args? args) {
    return args?.arguments ?? [];
  });
}

class Test2Controller {
  final testController = UseInstance<TestController>();

  Test2Controller() {
    Reactter.create(() => TestController());
  }
}

class Test3Controller {
  final test2Controller = UseInstance<Test2Controller>();

  Test3Controller() {
    Reactter.create(() => Test2Controller());
  }
}

final test3Controller = UseInstance<Test3Controller>();

class FakeInterceptorForCoverage<T, A extends Args?>
    extends MemoInterceptor<T, A> {
  @override
  void onInit(Memo<T, A> memo, A args) {
    // TODO: implement onInit
    super.onInit(memo, args);
  }

  @override
  void onValue(Memo<T, A> memo, A args, T value, bool fromCache) {
    // TODO: implement onValue
    super.onValue(memo, args, value, fromCache);
  }

  @override
  void onError(Memo<T, A> memo, A args, Object error) {
    // TODO: implement onError
    super.onError(memo, args, error);
  }

  @override
  void onFinish(Memo<T, A> memo, A args) {
    // TODO: implement onFinish
    super.onFinish(memo, args);
  }
}
