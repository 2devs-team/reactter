import 'dart:developer' as dev;

import 'package:meta/meta.dart';

import 'framework.dart';
import 'internals.dart';
import 'types.dart';

extension RtLoggerExt on RtInterface {
  /// Initializes the logger.
  ///
  /// This function sets up the logger for the application. You can provide
  /// a custom name for the logger and specify the output destination for
  /// the log messages.
  ///
  /// If no name is provided, the default name 'REACTTER' will be used.
  ///
  /// If no output is provided, the default output will be used.
  ///
  /// Parameters:
  ///   - [name]: An optional name for the logger. Defaults to 'REACTTER'.
  ///   - [output]: An optional [LogOutput] function to specify the log output destination.
  ///    The default output is the `dart:developer`'s `log` function.
  void initializeLogger({
    String name = 'REACTTER',
    LogOutput output = dev.log,
  }) {
    RtLogger.initialize(name: name, output: output);
  }
}

@internal
class RtLogger implements IStateObserver, IDependencyObserver {
  static RtLogger? instance;

  static void initialize({
    String name = 'REACTTER',
    LogOutput output = dev.log,
  }) {
    assert(instance == null, 'The logger has already been initialized.');

    if (kDebugMode) {
      instance ??= RtLogger._(name: name, output: output);
    }
  }

  final LogOutput output;
  final String name;

  RtLogger._({
    required this.name,
    required this.output,
  }) {
    Rt.addObserver(this);
  }

  void log(String message, {int level = 0, StackTrace? stackTrace}) {
    output.call(
      message,
      name: name,
      level: level,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  @override
  void onStateCreated(RtState state) {
    log(
      '${prettyFormat(state)} created.',
      level: LogLevel.finer,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onStateBound(RtState state, Object instance) {
    log(
      '${prettyFormat(state)} bound to ${prettyFormat(instance)}.',
      level: LogLevel.finer,
      stackTrace: StackTrace.current,
    );

    if (instance is! RtState && !Rt.isActive(instance)) {
      final T = instance.runtimeType;

      log(
        "The bound instance(${prettyFormat(instance)}) to state(${prettyFormat(state)}) is not in Reactter's context and cannot be disposed automatically.\n"
        "You can solve this problem in one of the following ways:\n"
        "\t- Call `dispose` method manually when state is no longer needed:\n"
        "\t\t`state.dispose();`\n"
        "\t- Create bound instance using the dependency injection methods:\n"
        "\t\t`Rt.register<$T>(() => $T(...));`\n"
        "\t\t`Rt.create<$T>(() => $T(...));`\n"
        "**Ignore this message if you are sure that it will be disposed.**",
        level: LogLevel.warning,
        stackTrace: StackTrace.current,
      );
    }
  }

  @override
  void onStateUnbound(RtState state, Object instance) {
    log(
      '${prettyFormat(state)} unbound from ${prettyFormat(instance)}.',
      level: LogLevel.finer,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onStateUpdated(RtState state) {
    log(
      '${prettyFormat(state)} updated.',
      level: LogLevel.finer,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onStateDisposed(RtState state) {
    log(
      '${prettyFormat(state)} disposed.',
      level: LogLevel.finer,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyRegistered(DependencyRef dependency) {
    log(
      '${prettyFormat(dependency)} registered.',
      level: LogLevel.fine,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyCreated(DependencyRef dependency, Object? instance) {
    log(
      '${prettyFormat(dependency)} created. Its instance: ${prettyFormat(instance)}.',
      level: LogLevel.fine,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyMounted(DependencyRef dependency, Object? instance) {
    log(
      '${prettyFormat(dependency)} mounted. Its instance: ${prettyFormat(instance)}.',
      level: LogLevel.fine,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyUnmounted(DependencyRef dependency, Object? instance) {
    log(
      '${prettyFormat(dependency)} unmounted. Its instance: ${prettyFormat(instance)}.',
      level: LogLevel.fine,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyDeleted(DependencyRef dependency, Object? instance) {
    log(
      '${prettyFormat(dependency)} deleted. Its instance: ${prettyFormat(instance)}.',
      level: LogLevel.fine,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyUnregistered(DependencyRef dependency) {
    log(
      '${prettyFormat(dependency)} unregistered.',
      level: LogLevel.fine,
      stackTrace: StackTrace.current,
    );
  }

  @override
  void onDependencyFailed(
    covariant DependencyRef<Object?> dependency,
    DependencyFail fail,
  ) {
    final T = dependency.type;
    final id = dependency.id;
    final idParam = id != null ? "id: '$id, '" : '';

    switch (fail) {
      case DependencyFail.alreadyRegistered:
        log(
          '${prettyFormat(dependency)} already registered.',
          level: LogLevel.info,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.alreadyCreated:
        log(
          '${prettyFormat(dependency)} already created.',
          level: LogLevel.info,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.alreadyDeleted:
        log(
          '${prettyFormat(dependency)} already deleted.',
          level: LogLevel.info,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.alreadyUnregistered:
        log(
          '${prettyFormat(dependency)} already unregistered.',
          level: LogLevel.info,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.builderRetained:
        log(
          "${prettyFormat(dependency)}'s instance retained because is in factory mode.",
          level: LogLevel.info,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.dependencyRetained:
        log(
          "${prettyFormat(dependency)} retained because is in singleton mode.",
          level: LogLevel.info,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.missingInstanceBuilder:
        log(
          "${prettyFormat(dependency)} builder was not registered previously.\n"
          "You should register the instance build with: \n"
          "\t`Rt.register<$T>(() => $T(...)$idParam);`\n"
          "\t`Rt.create<$T>(() => $T(...)$idParam);`",
          level: LogLevel.warning,
          stackTrace: StackTrace.current,
        );
        break;
      case DependencyFail.cannotUnregisterActiveInstance:
        log(
          "${prettyFormat(dependency)} couldn't unregister "
          "because ${prettyFormat(instance)} is active.\n"
          "You should delete the instance before with:\n"
          "\t`Rt.delete<$T>(${id ?? ''});`\n"
          "\t`Rt.destroy<$T>($idParam, onlyInstance: true);`\n",
          level: LogLevel.severe,
          stackTrace: StackTrace.current,
        );
        break;
    }
  }
}

@internal
String prettyFormat(Object? instance) {
  if (instance is DependencyRef) {
    final type = instance.type.toString().replaceAll('?', '');
    final id = instance.id;
    final idStr = id != null ? "id: '$id'" : null;
    final mode = instance is DependencyRegister
        ? instance.mode.label
        : Rt.getDependencyRegisterByRef(instance)?.mode.label;
    final modeStr = mode != null ? "mode: '$mode'" : null;
    final params = [
      if (idStr != null) idStr,
      if (modeStr != null) modeStr,
    ].join(', ');
    final paramsStr = params.isNotEmpty ? '($params)' : '';

    return '[DEPENDENCY | $type$paramsStr]';
  }

  if (instance is RtState) {
    final type = instance.runtimeType.toString();
    final label = instance.debugLabel;
    final labelStr = label != null ? "(debugLabel: '$label')" : '';

    if (instance is RtHook) {
      return '[HOOK | $type$labelStr | #${instance.hashCode}]';
    }

    return '[STATE | $type$labelStr | #${instance.hashCode}]';
  }

  return '[UNKNOWN | ${instance.runtimeType} | #${instance.hashCode}]';
}

@internal
typedef RtLoggerInitializeAssertionError = AssertionError;

/// Copy from `package:logging`.
/// [LogLevel]s to control logging output. Logging can be enabled to include all
/// levels above certain [LogLevel]. The predefined [LogLevel] constants below are sorted as
/// follows (in descending order): [LogLevel.shout], [LogLevel.severe],
/// [LogLevel.warning], [LogLevel.info], [LogLevel.config], [LogLevel.fine], [LogLevel.finer],
/// [LogLevel.finest], and [LogLevel.all].
///
/// We recommend using one of the predefined logging levels. If you define your
/// own level, make sure you use a value between those used in [LogLevel.all] and
/// [LogLevel.off].
class LogLevel {
  /// Special key to turn on logging for all levels (0).
  static const int all = 0;

  /// Key for highly detailed tracing (300).
  static const int finest = 300;

  /// Key for fairly detailed tracing (400).
  static const int finer = 400;

  /// Key for tracing information (500).
  static const int fine = 500;

  /// Key for static configuration messages (700).
  static const int config = 700;

  /// Key for informational messages (800).
  static const int info = 800;

  /// Key for potential problems (900).
  static const int warning = 900;

  /// Key for serious failures (1000).
  static const int severe = 1000;

  /// Key for extra debugging loudness (1200).
  static const int shout = 1200;

  /// Special key to turn off all logging (2000).
  static const int off = 2000;
}
