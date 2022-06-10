import 'package:reactter/reactter.dart';

class CounterContext extends ReactterContext {
  late final count = UseState(0, this);

  void increment() => count.value += 1;
  void decrement() => count.value -= 1;
}

class UseCount extends ReactterHook {
  int _count = 0;

  int get value => _count;

  UseCount(int initial, [ReactterContext? context])
      : _count = initial,
        super(context);

  void increment() => update(() => _count += 1);
  void decrement() => update(() => _count -= 1);
}

class Global {
  static final reverse = UseState(false);
  static final count = UseCount(0);
  static final maxCount = UseCount(10);

  static final Global _inst = Global._init();
  factory Global() => _inst;

  Global._init() {
    UseEffect(
      () {
        Future.delayed(const Duration(seconds: 1), doCount);
      },
      [count],
      UseEffect.dispatchEffect,
    );
  }

  static void doCount() {
    if (reverse.value && count.value <= 0) {
      reverse.value = false;
      maxCount.increment();
    }

    if (!reverse.value && count.value >= maxCount.value) {
      reverse.value = true;
    }

    reverse.value ? count.decrement() : count.increment();
  }
}

// It's need to instance it for can execute Global._init(This executes one time only).
final global = Global();
