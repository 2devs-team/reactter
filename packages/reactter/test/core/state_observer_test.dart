import 'package:reactter/reactter.dart';
import 'package:reactter/src/core/core.dart';
import 'package:test/test.dart';

class StateObserverTest extends StateObserver {
  int onStateCreatedCalledCount = 0;
  String? lastStateCreated;

  int onStateBoundCalledCount = 0;
  String? lastStateBound;
  Object? lastInstanceBound;

  int onStateUnboundCalledCount = 0;
  String? lastStateUnbound;

  int onStateUpdatedCalledCount = 0;
  String? lastStateUpdated;

  int onStateDisposedCalledCount = 0;
  String? lastStateDisposed;

  @override
  void onStateCreated(covariant State state) {
    lastStateCreated = state.debugLabel;
    onStateCreatedCalledCount++;
  }

  @override
  void onStateBound(covariant State state, Object instance) {
    lastStateBound = state.debugLabel;
    lastInstanceBound = instance;
    onStateBoundCalledCount++;
  }

  @override
  void onStateUnbound(covariant State state, Object instance) {
    lastStateUnbound = state.debugLabel;
    onStateUnboundCalledCount++;
  }

  @override
  void onStateUpdated(covariant State state) {
    lastStateUpdated = state.debugLabel;
    onStateUpdatedCalledCount++;
  }

  @override
  void onStateDisposed(covariant State state) {
    lastStateDisposed = state.debugLabel;
    onStateDisposedCalledCount++;
  }
}

void main() {
  group("StateObserverTest", () {
    test("should be observed when a state is created", () {
      final observer = StateObserverTest();
      Rt.addObserver(observer);

      UseState(0, debugLabel: "stateA");

      expect(observer.onStateCreatedCalledCount, 1);
      expect(observer.lastStateCreated, "stateA");

      UseState(1, debugLabel: "stateB");

      expect(observer.onStateCreatedCalledCount, 2);
      expect(observer.lastStateCreated, "stateB");

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is bound", () {
      final observer = StateObserverTest();
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      final instanceA = Object();
      stateA.bind(instanceA);

      expect(observer.onStateBoundCalledCount, 1);
      expect(observer.lastStateBound, "stateA");
      expect(observer.lastInstanceBound, instanceA);

      final stateB = UseState(1, debugLabel: "stateB");
      final instanceB = Object();
      stateB.bind(instanceB);

      expect(observer.onStateBoundCalledCount, 2);
      expect(observer.lastStateBound, "stateB");
      expect(observer.lastInstanceBound, instanceB);

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is unbound", () {
      final observer = StateObserverTest();
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      final instanceA = Object();
      stateA.bind(instanceA);
      stateA.unbind();

      expect(observer.onStateUnboundCalledCount, 1);
      expect(observer.lastStateUnbound, "stateA");
      expect(observer.lastInstanceBound, instanceA);

      final stateB = UseState(1, debugLabel: "stateB");
      final instanceB = Object();
      stateB.bind(instanceB);
      stateB.unbind();

      expect(observer.onStateUnboundCalledCount, 2);
      expect(observer.lastStateUnbound, "stateB");
      expect(observer.lastInstanceBound, instanceB);

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is updated", () {
      final observer = StateObserverTest();
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      stateA.value = 1;

      expect(observer.onStateUpdatedCalledCount, 1);
      expect(observer.lastStateUpdated, "stateA");

      final stateB = UseState(1, debugLabel: "stateB");
      stateB.value = 2;

      expect(observer.onStateUpdatedCalledCount, 2);
      expect(observer.lastStateUpdated, "stateB");

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is disposed", () {
      final observer = StateObserverTest();
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      stateA.dispose();

      expect(observer.onStateDisposedCalledCount, 1);
      expect(observer.lastStateDisposed, "stateA");

      final stateB = UseState(1, debugLabel: "stateB");
      stateB.dispose();

      expect(observer.onStateDisposedCalledCount, 2);
      expect(observer.lastStateDisposed, "stateB");

      Rt.removeObserver(observer);
    });

    test("should be observed when a nested state is updated", () {
      final observer = StateObserverTest();
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      final stateB = UseState(1, debugLabel: "stateB");
      stateB.bind(stateA);

      stateB.value = 2;

      expect(observer.onStateUpdatedCalledCount, 2);
      expect(observer.lastStateUpdated, "stateA");

      stateA.value = 3;

      expect(observer.onStateUpdatedCalledCount, 3);
      expect(observer.lastStateUpdated, "stateA");

      Rt.removeObserver(observer);
    });
  });
}
