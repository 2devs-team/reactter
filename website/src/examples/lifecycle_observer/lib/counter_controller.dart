import 'package:flutter_reactter/flutter_reactter.dart';

class CounterController extends LifecycleObserver {
  final count = Signal(0);

  void onInitialized() {
    print('CounterController initialized');
  }

  void onDidMount() {
    print('CounterController mounted');
  }

  void onWillMount() {
    print('CounterController will mount');
  }

  void onWillUpdate(RtState state) {
    print('CounterController will update by ${state.runtimeType}');
  }

  void onDidUpdate(RtState state) {
    print('CounterController did update by ${state.runtimeType}');
  }

  void onWillUnmount() {
    print('CounterController will unmount');
  }

  void onDidUnmount() {
    print('CounterController did unmount');
  }

  void increment() {
    count.value++;
  }

  void decrement() {
    count.value--;
  }
}
