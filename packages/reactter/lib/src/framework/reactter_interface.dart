// ignore_for_file: non_constant_identifier_names
part of '../framework.dart';

class _ReactterInterface with ReactterInstanceManager, ReactterEventManager {
  static final _reactterInterface = _ReactterInterface._();
  factory _ReactterInterface() => _reactterInterface;
  _ReactterInterface._();

  bool isInstancesBuilding = false;
  final _statesRecollected = <ReactterState>[];

  bool isLogEnable = true; //kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;

  /// It is used to create a new instance of a [ReactterState] class and attach it
  /// to a specific instance.
  T lazy<T extends ReactterState>(T Function() stateFn, Object instance) {
    ReactterState._instanceToAttach = instance;
    final state = stateFn();
    ReactterState._instanceToAttach = null;
    return state;
  }
}

final Reactter = _ReactterInterface();
