import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:reactter/reactter.dart';

@internal
class ReactterDevTools extends RtStateObserver {
  ReactterDevTools._() {
    print('ReactterDevTools initialized $hashCode');
    Rt.addObserver(this);
    _initDevTools();
  }

  static final debugInstance = kDebugMode
      ? ReactterDevTools._()
      : throw UnsupportedError(
          'Cannot use ReactterDevTools in release mode',
        );

  static final Set<RtState> states = {};

  @override
  void onStateCreated(covariant RtState state) {
    states.add(state);
    dev.postEvent('ext.reactter.onStateCreated', {
      'state': _getState(state),
    });
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
    states.remove(state);
    dev.postEvent('ext.reactter.onStateDisposed', {
      'state': _getState(state),
    });
  }

  void _initDevTools() {
    dev.registerExtension(
      'ext.reactter.getAllStates',
      (method, parameters) async {
        return dev.ServiceExtensionResponse.result(
          json.encode(_getStates()),
        );
      },
    );
  }

  Map<String, dynamic> _getStates() {
    return {
      'states': states.map(_getState).toList(),
    };
  }

  Map<String, dynamic> _getState(RtState state) {
    return {
      'id': state.hashCode,
      'type': state.runtimeType.toString(),
      'label': state.debugLabel,
      'properties': state.debugProperties.map(
        (key, value) {
          var valueEncode = value;

          try {
            valueEncode = jsonEncode(value);
          } catch (e) {
            valueEncode = value.toString();
          }

          return MapEntry(key, valueEncode);
        },
      ),
    };
  }
}
