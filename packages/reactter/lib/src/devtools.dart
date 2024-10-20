import 'dart:collection';
import 'dart:developer' as dev;

import 'package:meta/meta.dart';

import 'framework.dart';
import 'internals.dart';

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
  final LinkedHashMap<String, RtState> states = LinkedHashMap();

  static void _initializeDebugging() {
    if (kDebugMode) {
      _instance ??= ReactterDevTools._();
    }
  }

  ReactterDevTools._() {
    Rt.addObserver(this);
  }

  @override
  void onStateCreated(covariant RtState state) {
    final stateKey = state.hashCode.toString();
    states.putIfAbsent(stateKey, () => state);
    dev.postEvent('ext.reactter.onStateCreated', {
      'stateKey': stateKey,
    });
  }

  @override
  void onStateBound(covariant RtState state, Object instance) {
    final stateKey = state.hashCode.toString();
    dev.postEvent('ext.reactter.onStateBound', {
      'stateKey': stateKey,
    });
  }

  @override
  void onStateUnbound(covariant RtState state, Object instance) {
    final stateKey = state.hashCode.toString();
    dev.postEvent('ext.reactter.onStateUnbound', {
      'stateKey': stateKey,
    });
  }

  @override
  void onStateUpdated(covariant RtState state) {
    final stateKey = state.hashCode.toString();
    dev.postEvent('ext.reactter.onStateUpdated', {
      'stateKey': stateKey,
    });
  }

  @override
  void onStateDisposed(covariant RtState state) {
    final stateKey = state.hashCode.toString();
    states.remove(stateKey);
    dev.postEvent('ext.reactter.onStateDisposed', {
      'stateKey': stateKey,
    });
  }

  Map<String, dynamic>? getStateDetails(String stateKey) {
    final state = states[stateKey];

    if (state == null) return null;

    return {
      'type': state.runtimeType.toString(),
      'label': state.debugLabel,
    };
  }

  Map<String, dynamic>? getDebugInfo(String stateKey) {
    final state = states[stateKey];

    return state?.debugInfo;
  }

  String getPropertyValue(value) {
    if (value is List) {
      return getListString(value);
    } else if (value is Map) {
      return getMapString(value);
    } else if (value is Set) {
      return getSetString(value);
    } else {
      return value.toString();
    }
  }

  String getListString(List list) {
    var listString = list.toString();
    if (listString.length > 60) {
      listString = '${listString.substring(0, 60)}...]';
    }
    return listString;
  }

  String getMapString(Map map) {
    var mapString = map.toString();
    if (mapString.length > 60) {
      mapString = '${mapString.substring(0, 60)}...}';
    }
    return mapString;
  }

  String getSetString(Set set) {
    var setString = set.toString();
    if (setString.length > 60) {
      setString = '${setString.substring(0, 60)}...}';
    }
    return setString;
  }
}
