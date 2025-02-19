import 'package:reactter/reactter.dart';
import 'package:reactter/src/internals.dart';
import 'package:test/test.dart';

void main() {
  group("RtStateObserver", () {
    test("should be observed when a state is created", () {
      int onCreatedCalledCount = 0;
      String? lastStateCreated;

      final observer = RtStateObserver(
        onCreated: (state) {
          expect(state, isA<RtState>());
          onCreatedCalledCount++;
          lastStateCreated = state.debugLabel;
        },
      );
      Rt.addObserver(observer);

      UseState(0, debugLabel: "stateA");

      expect(onCreatedCalledCount, 1);
      expect(lastStateCreated, "stateA");

      UseState(1, debugLabel: "stateB");

      expect(onCreatedCalledCount, 2);
      expect(lastStateCreated, "stateB");

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is bound", () {
      int onBoundCalledCount = 0;
      String? lastStateBound;
      dynamic lastInstanceBound;

      final observer = RtStateObserver(
        onBound: (state, instance) {
          expect(state, isA<RtState>());
          onBoundCalledCount++;
          lastStateBound = state.debugLabel;
          lastInstanceBound = instance;
        },
      );
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      final instanceA = Object();
      stateA.bind(instanceA);

      expect(onBoundCalledCount, 1);
      expect(lastStateBound, "stateA");
      expect(lastInstanceBound, instanceA);

      final stateB = UseState(1, debugLabel: "stateB");
      final instanceB = Object();
      stateB.bind(instanceB);

      expect(onBoundCalledCount, 2);
      expect(lastStateBound, "stateB");
      expect(lastInstanceBound, instanceB);

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is unbound", () {
      int onUnboundCalledCount = 0;
      String? lastStateUnbound;
      dynamic lastInstanceUnbound;

      final observer = RtStateObserver(
        onUnbound: (state, instance) {
          expect(state, isA<RtState>());
          onUnboundCalledCount++;
          lastStateUnbound = state.debugLabel;
          lastInstanceUnbound = instance;
        },
      );
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      final instanceA = Object();
      stateA.bind(instanceA);
      stateA.unbind();

      expect(onUnboundCalledCount, 1);
      expect(lastStateUnbound, "stateA");
      expect(lastInstanceUnbound, instanceA);

      final stateB = UseState(1, debugLabel: "stateB");
      final instanceB = Object();
      stateB.bind(instanceB);
      stateB.unbind();

      expect(onUnboundCalledCount, 2);
      expect(lastStateUnbound, "stateB");
      expect(lastInstanceUnbound, instanceB);

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is updated", () {
      int onUpdatedCalledCount = 0;
      String? lastStateUpdated;

      final observer = RtStateObserver(
        onUpdated: (state) {
          expect(state, isA<RtState>());
          onUpdatedCalledCount++;
          lastStateUpdated = state.debugLabel;
        },
      );
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      stateA.value = 1;

      expect(onUpdatedCalledCount, 1);
      expect(lastStateUpdated, "stateA");

      final stateB = UseState(1, debugLabel: "stateB");
      stateB.value = 2;

      expect(onUpdatedCalledCount, 2);
      expect(lastStateUpdated, "stateB");

      Rt.removeObserver(observer);
    });

    test("should be observed when a state is disposed", () {
      int onDisposedCalledCount = 0;
      String? lastStateDisposed;

      final observer = RtStateObserver(
        onDisposed: (state) {
          expect(state, isA<RtState>());
          onDisposedCalledCount++;
          lastStateDisposed = state.debugLabel;
        },
      );
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      stateA.dispose();

      expect(onDisposedCalledCount, 1);
      expect(lastStateDisposed, "stateA");

      final stateB = UseState(1, debugLabel: "stateB");
      stateB.dispose();

      expect(onDisposedCalledCount, 2);
      expect(lastStateDisposed, "stateB");

      Rt.removeObserver(observer);
    });

    test("should be observed when a nested state is updated", () {
      int onStateUpdatedCalledCount = 0;
      String? lastStateUpdated;

      final observer = RtStateObserver(
        onUpdated: (state) {
          expect(state, isA<RtState>());
          onStateUpdatedCalledCount++;
          lastStateUpdated = state.debugLabel;
        },
      );
      Rt.addObserver(observer);

      final stateA = UseState(0, debugLabel: "stateA");
      final stateB = UseState(1, debugLabel: "stateB");
      stateB.bind(stateA);

      stateB.value = 2;

      expect(onStateUpdatedCalledCount, 2);
      expect(lastStateUpdated, "stateA");

      stateA.value = 3;

      expect(onStateUpdatedCalledCount, 3);
      expect(lastStateUpdated, "stateA");

      Rt.removeObserver(observer);
    });
  });
}
