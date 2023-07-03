// ignore_for_file: non_constant_identifier_names
part of '../framework.dart';

class _ReactterInterface with ReactterInstanceManager, ReactterEventManager {
  static final _reactterInterface = _ReactterInterface._();

  bool _instancesBuilding = false;
  final _statesRecollected = <ReactterState>[];

  factory _ReactterInterface() {
    return _reactterInterface;
  }

  _ReactterInterface._();

  bool isLogEnable = true; //kDebugMode;
  LogWriterCallback log = defaultLogWriterCallback;
}

final Reactter = _ReactterInterface();
