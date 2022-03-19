// ignore_for_file: prefer_function_declarations_over_variables

library reactter;

import 'package:get/get.dart';
import 'package:reactter/utils/reaccter_exceptions.dart';
import 'package:reactter/core/reactter_routing_controller.dart';
import 'package:reactter/core/reactter_state.dart';
import 'package:reactter/utils/reactter_types.dart';

class ReactterController extends GetxController {
  final _routingController = Get.find<RoutingController>();

  bool loading = false;
  String route = '';
  bool Function() notReloadIf = () => false;
  final List<Reactter> statesList = [];

  @override
  void onInit() async {
    super.onInit();
    _routingController.addListenerId('routing', onRoutingChanged);
  }

  @override
  void onClose() async {
    _routingController.removeListenerId('routing', onRoutingChanged);
    super.onClose();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    if (ids != null && ids.isNotEmpty) {
      super.update([...ids, 'changed'], condition);
      super.update();

      return;
    }
    super.update(['changed']);
    super.update();
  }

  void onRoutingChanged() {
    final routing = _routingController.routing!;

    if (!routing.isOverlayOpen &&
        !routing.isBackFromOverlay &&
        routing.isCurrent &&
        routing.current == route &&
        !notReloadIf()) {
      onReload();
    }
  }

  void onReload() {
    for (var state in statesList) {
      state.reset();
    }
  }

  void isLoading(bool _loading) {
    loading = _loading;
    update(['loading']);
  }

  Future<T?>? executeAsync<T>(
    Future<T> Function() action, {
    FutureVoidCallback? onStartCall,
    FutureVoidCallback? onEndCall,
    void Function(dynamic error)? onError,
  }) async {
    try {
      await onStartCall?.call();

      return await action();
    } catch (e) {
      if (onError != null) {
        onError(e);
      }

      AsyncException(originalError: e);

      return null;
    } finally {
      await onEndCall?.call();
    }
  }
}
