// ignore_for_file: prefer_function_declarations_over_variables
library reactter;

import 'package:get/get.dart';
import 'package:reactter/utils/reaccter_exceptions.dart';
import 'package:reactter/core/reactter_routing_controller.dart';
import 'package:reactter/reactter.dart';
import 'package:reactter/utils/reactter_types.dart';

class ReactterController extends GetxController {
  final _routingController = Get.find<RoutingController>();

  get getInstance => this;

  String route = '';
  final List<UseState> statesList = [];
  bool Function() notReloadIf = () => false;

  Map<String, UseState> get states => {};

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
    // for (var state in states) {
    //   state.reset();
    // }
  }

  Future<T?>? callAsync<T>(
    Future<T> Function() callback, {
    FutureVoidCallback? willCall,
    FutureVoidCallback? didCall,
    void Function(dynamic error)? onError,
  }) async {
    try {
      await willCall?.call();

      return await callback();
    } catch (e) {
      if (onError != null) {
        onError(e);
      }

      AsyncException(originalError: e);

      return null;
    } finally {
      await didCall?.call();
    }
  }

  UseState<T> useState<T>(
    String key,
    T initial, {
    UpdateCallback<T>? willUpdate,
    UpdateCallback<T>? didUpdate,
    bool? alwayUpdate,
  }) {
    final state = UseState<T>(
      // key,
      initial,
      willUpdate: willUpdate,
      didUpdate: didUpdate,
      // update: update,
      alwaysUpdate:
          (alwayUpdate ?? false) || T == Map || T == List || T == Object,
    );
    statesList.addAll([state]);
    return state;
  }

  Future<void> waitFor(bool Function() predicate) async {
    return Future.doWhile(
      () => Future.delayed(
        const Duration(milliseconds: 1),
        () => !predicate(),
      ),
    );
  }
}
