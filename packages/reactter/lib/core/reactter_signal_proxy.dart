part of '../core.dart';

mixin ReactterSignalProxy {
  /// The purpose of this method  is to add a `Signal` object to the class
  /// that implements it, which can then be used to trigger reactions or
  /// updates in response to changes in the application state.
  void addSignal(Signal signal);
}
