part of '../framework.dart';

///{@template reactter.rt_interface}
/// A class that represents the interface for Rt.
///
/// It is intended to be used as a mixin with other classes.
/// {@endtemplate}
class RtInterface
    with
        StateManagement<RtState>,
        DependencyInjection,
        EventHandler,
        ObserverManager {}

/// {@template reactter.rt}
/// This class represents the interface for the Reactter framework.
/// It provides methods and properties for interacting with the Reactter framework.
/// {@endtemplate}
final Rt = RtInterface();
