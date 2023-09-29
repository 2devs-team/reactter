// ignore_for_file: non_constant_identifier_names
part of '../framework.dart';

@internal
class ReactterInterface
    with
        ReactterInstanceManager,
        ReactterEventManager,
        ReactterLogger,
        ReactterAttacher {
  static final _reactterInterface = ReactterInterface._();
  @internal
  factory ReactterInterface() => _reactterInterface;
  ReactterInterface._();
}

final Reactter = ReactterInterface();
