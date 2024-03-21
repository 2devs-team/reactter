import 'package:reactter/reactter.dart';
import 'package:test/test.dart';

void main() {
  group("lazyState", () {
    test("should create a lazy state", () {
      bool isCreated = false;
      final state = UseState(0);
      late final computed = Reactter.lazyState(
        () => UseCompute(
          () {
            isCreated = true;
            return state.value + 1;
          },
          [state],
        ),
        state,
      );

      expect(isCreated, false);

      state.value = 1;

      expect(isCreated, false);
      expect(computed.value, 2);
      expect(isCreated, true);

      state.value += 1;

      expect(computed.value, 3);
    });
  });

  group("untracked", () {
    test("should run the callback without tracking the changes", () {
      final state = UseState(0);
      final computed = UseCompute(() => state.value + 1, [state]);

      Reactter.untracked(() {
        state.value = 2;

        expect(computed.value, 1);
      });

      expect(computed.value, 1);
    });

    test("should run the callback as nested untracked", () {
      final state = UseState(0);
      final computed = UseCompute(() => state.value + 1, [state]);

      Reactter.untracked(() {
        Reactter.untracked(() {
          state.value = 2;

          expect(computed.value, 1);
        });

        state.value += 1;

        expect(computed.value, 1);
      });

      expect(computed.value, 1);
    });
  });

  group("batch", () {
    test("should run the callback and change the state after the batch", () {
      final state = UseState(0);
      final computed = UseCompute(() => state.value + 1, [state]);

      Reactter.batch(() {
        state.value = 2;

        expect(computed.value, 1);
      });

      expect(computed.value, 3);
    });

    test("should run the callback as nested batch", () {
      final state = UseState(0);
      final computed = UseCompute(() => state.value + 1, [state]);

      Reactter.batch(() {
        Reactter.batch(() {
          state.value = 2;

          expect(computed.value, 1);
        });

        state.value += 1;

        expect(computed.value, 1);
      });

      expect(computed.value, 4);
    });
  });
}
