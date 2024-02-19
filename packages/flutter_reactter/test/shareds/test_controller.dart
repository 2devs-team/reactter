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

class TestController extends LifecycleObserver {
  final signalString = Signal("initial");
  final signalInt = Signal(0);
  final stateBool = UseState(false);
  final stateString = UseState("initial");
  final stateInt = UseState(0);
  final stateDouble = UseState(0.0);
  final stateList = UseState([]);
  final stateMap = UseState({});
  final stateClass = UseState<TestClass?>(null);
  final stateAsync = UseAsyncState("initial", _resolveStateAsync);

  int onInitializedCalledCount = 0;
  int onWillMountCalledCount = 0;
  int onDidMountCalledCount = 0;
  int onWillUpdateCalledCount = 0;
  int onDidUpdateCalledCount = 0;
  int onWillUnmountCalledCount = 0;
  int onDidUnmountCalledCount = 0;
  ReactterState? lastState;

  @override
  void onInitialized() {
    onInitializedCalledCount++;
  }

  @override
  void onWillMount() {
    onWillMountCalledCount++;
  }

  @override
  void onDidMount() {
    onDidMountCalledCount++;
  }

  @override
  void onWillUpdate(ReactterState? state) {
    onWillUpdateCalledCount++;
    lastState = state;
  }

  @override
  void onDidUpdate(ReactterState? state) {
    onDidUpdateCalledCount++;
    lastState = state;
  }

  @override
  void onWillUnmount() {
    onWillUnmountCalledCount++;
  }

  @override
  void onDidUnmount() {
    onDidUnmountCalledCount++;
  }
}
