import 'package:flutter_reactter/flutter_reactter.dart';

class CounterController extends RtDependencyLifecycle {
  final count = Signal(0);

  void increment() {
    count.value++;
  }

  void decrement() {
    count.value--;
  }

  @override
  void onCreated() {
    print('CounterController initialized');
  }

  @override
  void onDidMount() {
    print('CounterController mounted');
  }

  @override
  void onWillMount() {
    print('CounterController will mount');
  }

  @override
  void onWillUpdate(RtState state) {
    print('CounterController will update by ${state.runtimeType}');
  }

  @override
  void onDidUpdate(RtState state) {
    print('CounterController did update by ${state.runtimeType}');
  }

  @override
  void onWillUnmount() {
    print('CounterController will unmount');
  }

  @override
  void onDidUnmount() {
    print('CounterController did unmount');
  }
}
