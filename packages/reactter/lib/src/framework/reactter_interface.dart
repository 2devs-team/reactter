part of '../framework.dart';

@internal
class ReactterInterface
    with ReactterInstanceManager, ReactterEventManager, ReactterLogger {
  static final _reactterInterface = ReactterInterface._();
  factory ReactterInterface() => _reactterInterface;
  ReactterInterface._();
}
