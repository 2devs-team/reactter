import 'package:flutter_test/flutter_test.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/src/logger.dart';

class StateTest with RtState {
  StateTest._();

  factory StateTest() {
    return Rt.createState(() => StateTest._());
  }

  @override
  String? get debugLabel => 'StateTest';

  @override
  Map<String, dynamic> get debugInfo => {};
}

void main() {
  final List<Map<String, dynamic>> logs = [];

  void output(
    String message, {
    required String name,
    required int level,
    StackTrace? stackTrace,
  }) {
    logs.add({
      'message': message,
      'name': name,
      'level': level,
      'stackTrace': stackTrace,
    });
  }

  List<Map<String, dynamic>> initialized() {
    try {
      Rt.initializeLogger(name: 'Reactter Test', output: output);
    } catch (e) {
      expect(e, isInstanceOf<RtLoggerInitializeAssertionError>());
    }

    expect(RtLogger.instance, isNotNull);

    return logs;
  }

  group('Logger', () {
    test('should be initialized', () {
      initialized();
    });

    test('should be log', () {
      initialized();

      final logger = RtLogger.instance;

      logger?.log('test');

      expect(logs.last['name'], 'Reactter Test');
      expect(logs.last['level'], LogLevel.all);
      expect(logs.last['message'], 'test');
      expect(logs.last['stackTrace'], isNotNull);
    });

    test('should be state log', () {
      initialized();

      final uState = UseState('test');

      expect(logs.last['level'], LogLevel.finer);
      expect(logs.last['message'], '${prettyFormat(uState)} created.');

      final stateTest = StateTest();

      expect(logs.last['level'], LogLevel.finer);
      expect(logs.last['message'], '${prettyFormat(stateTest)} created.');

      final instanceToBind = Symbol('test');

      uState.bind(instanceToBind);

      expect(logs.last['level'], LogLevel.warning);
      expect(
        logs.last['message'],
        startsWith(
          'The bound instance(${prettyFormat(instanceToBind)}) to state(${prettyFormat(uState)})',
        ),
      );

      uState.unbind();

      expect(logs.last['level'], LogLevel.finer);
      expect(
        logs.last['message'],
        '${prettyFormat(uState)} unbound from ${prettyFormat(instanceToBind)}.',
      );

      uState.value = 'new value';

      expect(logs.last['level'], LogLevel.finer);
      expect(logs.last['message'], '${prettyFormat(uState)} updated.');

      uState.dispose();

      expect(logs.last['level'], LogLevel.finer);
      expect(logs.last['message'], '${prettyFormat(uState)} disposed.');
    });

    test('should be dependency log', () {
      initialized();

      final instance = StateTest();
      final id = 'test';

      Rt.register(() => instance, id: id);

      expect(logs.last['level'], LogLevel.fine);
      expect(
        logs.last['message'],
        '${prettyFormat(RtDependencyRef<StateTest>(id))} registered.',
      );

      final dependency = Rt.getDependencyRegisterByRef(
        RtDependencyRef<StateTest>(id),
      );

      Rt.create(() => instance, id: id);

      expect(logs.last['level'], LogLevel.fine);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} created. Its instance: ${prettyFormat(instance)}.',
      );

      Rt.emit(dependency, Lifecycle.didMount, instance);

      expect(logs.last['level'], LogLevel.fine);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} mounted. Its instance: ${prettyFormat(instance)}.',
      );

      Rt.emit(dependency, Lifecycle.didUnmount, instance);

      expect(logs.last['level'], LogLevel.fine);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} unmounted. Its instance: ${prettyFormat(instance)}.',
      );

      instance.dispose();

      Rt.destroy<StateTest>(id: id, onlyInstance: true);

      expect(logs.last['level'], LogLevel.fine);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} deleted. Its instance: ${prettyFormat(instance)}.',
      );

      Rt.unregister<StateTest>(id);

      expect(logs.last['level'], LogLevel.fine);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} unregistered.',
      );

      Rt.register(() => instance, id: id);
      Rt.register(() => instance, id: id);

      expect(logs.last['level'], LogLevel.info);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} already registered.',
      );

      Rt.create(() => instance, id: id);
      Rt.create(() => instance, id: id);

      expect(logs.last['level'], LogLevel.info);
      expect(
        logs.last['message'],
        '${prettyFormat(dependency)} already created.',
      );

      Rt.delete<StateTest>(id);
      Rt.delete<StateTest>(id);

      expect(logs.last['level'], LogLevel.info);
      expect(
        logs.last['message'],
        '${prettyFormat(RtDependencyRef<StateTest>(id))} already deleted.',
      );

      Rt.unregister<StateTest>(id);
      Rt.unregister<StateTest>(id);

      expect(logs.last['level'], LogLevel.info);
      expect(
        logs.last['message'],
        '${prettyFormat(RtDependencyRef<StateTest>(id))} already unregistered.',
      );

      Rt.create(() => StateTest(), id: id, mode: DependencyMode.factory);
      final dependencyFactoryRef = Rt.getDependencyRegisterByRef(
        RtDependencyRef<StateTest>(id),
      );
      Rt.delete<StateTest>(id);

      expect(logs.last['level'], LogLevel.info);
      expect(
        logs.last['message'],
        "${prettyFormat(dependencyFactoryRef)}'s instance retained because it's factory mode.",
      );

      Rt.destroy<StateTest>(id: id);
      Rt.create(() => StateTest(), id: id, mode: DependencyMode.singleton);
      final dependencySingletonRef = Rt.getDependencyRegisterByRef(
        RtDependencyRef<StateTest>(id),
      );
      Rt.delete<StateTest>(id);

      expect(logs.last['level'], LogLevel.info);
      expect(
        logs.last['message'],
        "${prettyFormat(dependencySingletonRef)} retained because it's singleton mode.",
      );

      Rt.destroy<StateTest>(id: id);
      Rt.get<StateTest>(id);

      expect(logs.last['level'], LogLevel.warning);
      expect(
        logs.last['message'],
        startsWith(
            "${prettyFormat(RtDependencyRef<StateTest>(id))} couldn't register."),
      );

      Rt.create(() => StateTest(), id: id);
      Rt.unregister<StateTest>(id);

      expect(logs.last['level'], LogLevel.severe);
      expect(
        logs.last['message'],
        startsWith(
          "${prettyFormat(RtDependencyRef<StateTest>(id))} couldn't unregister",
        ),
      );
    });
  });
}
