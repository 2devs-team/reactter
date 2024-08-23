import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:reactter/reactter.dart';

extension RtExt on RtInterface {
  void initializeDebugging() {
    if (kDebugMode) {
      ReactterDevTools._initializeDebugging();
    }
  }
}

@internal
class ReactterDevTools extends RtStateObserver {
  static ReactterDevTools? _instance;

  static void _initializeDebugging() {
    if (kDebugMode) {
      _instance ??= ReactterDevTools._();
    }
  }

  final Map<String, RtState> states = {};

  List<String> get stateIdRefs => states.keys.toList();

  ReactterDevTools._() {
    print('ReactterDevTools initialized $hashCode');
    Rt.addObserver(this);
    _initDevTools();
  }

  @override
  void onStateCreated(covariant RtState state) {
    states[state.hashCode.toString()] = state;
    dev.postEvent('ext.reactter.onStateCreated', {
      'state': _getState(state),
    });
    print("states len: ${states.length}");
    print("state created: ${state.debugLabel}");
  }

  @override
  void onStateBound(covariant RtState state, Object instance) {
    dev.postEvent('ext.reactter.onStateBound', {
      'state': _getState(state),
      'instance': instance.hashCode,
    });
  }

  @override
  void onStateUnbound(covariant RtState state, Object instance) {
    dev.postEvent('ext.reactter.onStateUnbound', {
      'state': _getState(state),
      'instance': instance.hashCode,
    });
  }

  @override
  void onStateUpdated(covariant RtState state) {
    dev.postEvent('ext.reactter.onStateUpdated', {
      'state': _getState(state),
    });
  }

  @override
  void onStateDisposed(covariant RtState state) {
    states.remove(state.hashCode.toString());
    dev.postEvent('ext.reactter.onStateDisposed', {
      'state': _getState(state),
    });
    print("states len: ${states.length}");
    print("state disposed: ${state.debugLabel}");
  }

  void _initDevTools() {
    dev.registerExtension(
      'ext.reactter.getStateIdRefs',
      (method, parameters) async {
        return dev.ServiceExtensionResponse.result(
          json.encode(stateIdRefs),
        );
      },
    );
  }

  Map<String, dynamic> _getState(RtState state) {
    return {
      'id': state.hashCode,
      'type': state.runtimeType.toString(),
      'label': state.debugLabel,
      'properties': state.debugProperties.map(
        (key, value) {
          var valueEncode = value;

          valueEncode = value.toString();

          return MapEntry(key, valueEncode);
        },
      ),
    };
  }
}
