import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';

class CountTest extends RtState {
  int _count = 0;
  int get count => _count;
  set count(int value) {
    if (_count != value) {
      update(() {
        _count = value;
      });
    }
  }

  @override
  String? get debugLabel => 'CountTest';

  @override
  Map<String, dynamic> get debugInfo => {
        "count": _count,
      };
}

class StateTest with RtState {
  StateTest._() {
    assert(dependencyInjection == Rt);
    assert(stateManagement == Rt);
    assert(eventHandler == Rt);
  }

  factory StateTest() {
    return Rt.createState(() => StateTest._());
  }

  @override
  String? get debugLabel => 'State2';
}

void main() {
  group('RtState', () {
    test('should create a state object within the BindingZone', () {
      expect(() => CountTest(), throwsA(isA<AssertionError>()));

      final countState = Rt.createState(() => CountTest());
      expect(countState.debugLabel, 'CountTest');

      final state = StateTest();
      expect(state.debugLabel, 'State2');
    });

    test('should create a state using Dependency Injection', () {
      final countState = Rt.create<CountTest>(() => CountTest());

      expect(countState?.debugLabel, 'CountTest');

      Rt.delete<CountTest>();

      final state = Rt.create<StateTest>(() => StateTest());
      expect(state?.debugLabel, 'State2');

      Rt.delete<StateTest>();
    });

    test('should update the state', () {
      final countState = Rt.createState(() => CountTest());
      expect(countState.count, 0);

      countState.count = 1;
      expect(countState.count, 1);
    });

    test('should have debug info', () {
      final countState = Rt.createState(() => CountTest());
      expect(countState.debugInfo, {"count": 0});

      countState.count = 1;
      expect(countState.debugInfo, {"count": 1});

      final state = StateTest();
      expect(state.debugInfo, {});
    });
  });
}
