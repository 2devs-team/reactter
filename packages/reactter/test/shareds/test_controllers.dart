import 'package:reactter/reactter.dart';

class TestClass {
  final String prop;

  TestClass(this.prop);
}

class TestStore {
  final int count;

  TestStore({this.count = 0});
}

class IncrementAction extends RtAction<int> {
  IncrementAction({int quantity = 1})
      : super(type: 'INCREMENT', payload: quantity);
}

class DecrementAction extends RtAction<int> {
  DecrementAction({int quantity = 1})
      : super(type: 'DECREMENT', payload: quantity);
}

class IncrementActionCallable extends RtActionCallable<TestStore, int> {
  IncrementActionCallable({int quantity = 1})
      : super(type: 'INCREMENT', payload: quantity);

  @override
  TestStore call(TestStore state) {
    return TestStore(count: state.count + payload);
  }
}

class DecrementActionCallable extends RtActionCallable<TestStore, int> {
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

TestStore _reducer(TestStore state, RtAction action) {
  if (action is RtActionCallable) {
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

class TestController {
  final signalString = Signal("initial", debugLabel: "signalString");
  final stateBool = UseState(false, debugLabel: "stateBool");
  final stateString = UseState("initial", debugLabel: "stateString");
  final stateInt = UseState(0, debugLabel: "stateInt");
  final stateDouble = UseState(0.0, debugLabel: "stateDouble");
  final stateList = UseState([], debugLabel: "stateList");
  final stateMap = UseState({}, debugLabel: "stateMap");
  final stateClass = UseState<TestClass?>(null, debugLabel: "stateClass");
  final stateAsync = UseAsyncState(
    _resolveStateAsync,
    "initial",
    debugLabel: "stateAsync",
  );
  final stateAsyncWithArg = UseAsyncState.withArg(
    _resolveStateAsync,
    "initial",
    debugLabel: "stateAsyncWithArg",
  );
  final stateAsyncWithError = UseAsyncState(
    () async {
      await Future.delayed(Duration(milliseconds: 1));
      throw Exception("has a error");
    },
    "initial",
    debugLabel: "stateAsyncWithError",
  );
  final stateReduce = UseReducer(
    _reducer,
    TestStore(count: 0),
    debugLabel: "stateReduce",
  );

  late final stateCompute = Rt.lazyState(
    () => UseCompute(
      () => (stateInt.value + stateDouble.value).clamp(5, 10),
      [stateInt, stateDouble],
      debugLabel: "stateCompute",
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

  final asyncMemo = Memo<dynamic, Args>(
    (Args? args) {
      if (args is Args1<Future>) return args.arg1;

      if (args is Args1<Error>) {
        throw args.arg1;
      }

      return args?.arguments ?? [];
    },
    MemoSafeAsyncInterceptor(),
  );

  final inlineMemo = Memo.inline((Args? args) {
    return args?.arguments ?? [];
  });

  // TestController() {
  //   assert(dependencyInjection == Rt);
  //   assert(stateManagement == Rt);
  //   assert(eventHandler == Rt);
  // }
}

class TestLifecycleController with RtDependencyLifecycle {
  final stateString = UseState("initial");
  final stateInt = UseState(0);

  int onCreatedCalledCount = 0;
  int onWillMountCalledCount = 0;
  int onDidMountCalledCount = 0;
  int onWillUpdateCalledCount = 0;
  int onDidUpdateCalledCount = 0;
  int onWillUnmountCalledCount = 0;
  int onDidUnmountCalledCount = 0;
  RtState? lastState;

  @override
  void onCreated() {
    onCreatedCalledCount++;
    super.onCreated();
  }

  @override
  void onWillMount() {
    onWillMountCalledCount++;
    super.onWillMount();
  }

  @override
  void onDidMount() {
    onDidMountCalledCount++;
    super.onDidMount();
  }

  @override
  void onWillUpdate(RtState? state) {
    onWillUpdateCalledCount++;
    lastState = state;
    super.onWillUpdate(state);
  }

  @override
  void onDidUpdate(RtState? state) {
    onDidUpdateCalledCount++;
    lastState = state;
    super.onDidUpdate(state);
  }

  @override
  void onWillUnmount() {
    onWillUnmountCalledCount++;
    super.onWillUnmount();
  }

  @override
  void onDidUnmount() {
    onDidUnmountCalledCount++;
    super.onDidUnmount();
  }
}

class Test2Controller {
  final testController = UseDependency<TestController>();

  Test2Controller() {
    Rt.create(() => TestController());
  }
}

class Test3Controller {
  final test2Controller = UseDependency<Test2Controller>();

  Test3Controller() {
    Rt.create(() => Test2Controller());
  }
}

final test3Controller = UseDependency<Test3Controller>();

class FakeInterceptorForCoverage<T, A> extends MemoInterceptor<T, A> {
  @override
  void onInit(Memo<T, A> memo, A args) {
    super.onInit(memo, args);
  }

  @override
  void onValue(Memo<T, A> memo, A args, T value, bool fromCache) {
    super.onValue(memo, args, value, fromCache);
  }

  @override
  void onError(Memo<T, A> memo, A args, Object error) {
    super.onError(memo, args, error);
  }

  @override
  void onFinish(Memo<T, A> memo, A args) {
    super.onFinish(memo, args);
  }
}
