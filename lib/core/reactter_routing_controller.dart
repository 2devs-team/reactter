import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoutingState extends Routing {
  bool isBackFromOverlay = false;

  RoutingState({
    current = '',
    previous = '',
    args,
    removed = '',
    route,
    isBack,
    isSnackbar,
    isBottomSheet,
    isDialog,
    this.isBackFromOverlay = false,
  }) : super(
          current: current,
          previous: previous,
          args: args,
          removed: removed,
          route: route,
          isBack: isBack,
          isBottomSheet: isBottomSheet,
          isDialog: isDialog,
        );

  bool get isOverlayOpen =>
      (isDialog ?? false) || (isBottomSheet ?? false) || (route is PopupRoute);

  bool get isCurrent => route?.isCurrent ?? false;
}

class RoutingController extends GetxController with NavigatorObserver {
  RoutingState? _routing;
  List<Route<dynamic>> routeStack = [];

  RoutingState? get routing => _routing;
  set routing(RoutingState? value) {
    _routing = value;

    update(['routing']);
  }

  bool isRouteOnStackPredicate(bool Function(Route<dynamic>) predicate) {
    final Route<dynamic>? routeExists = routeStack.firstWhereOrNull(predicate);

    return routeExists != null;
  }

  bool isRouteOnStack(String route) => isRouteOnStackPredicate(
        (stackRoute) => stackRoute.settings.name == route,
      );

  Future<void> toNamedUntil(String routeName,
      {bool Function(Route<dynamic> stackRoute)? predicate,
      dynamic arguments,
      int? id,
      bool preventDuplicates = true,
      Map<String, String>? parameters}) async {
    final _predicate =
        predicate ?? (stackRoute) => stackRoute.settings.name == routeName;

    bool routeExists = isRouteOnStackPredicate(_predicate);

    if (routeExists) {
      Get.until(_predicate);
    } else {
      await Get.toNamed(
        routeName,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
      );
    }
  }

  void popRoute(String route) =>
      routeStack.removeWhere((stackRoute) => stackRoute.settings.name == route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is! GetModalBottomSheetRoute) routeStack.removeLast();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // route is! GetModalBottomSheetRoute && route is! ModalRoute && PopupRoute
    if (route is! GetModalBottomSheetRoute) {
      routeStack.add(route);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute!);
  }

  bool isOverlayOpened = false;

  void routingCallback(Routing? _routing) {
    bool isBackFromOverlay = isOverlayOpened && (_routing?.isBack ?? false);

    routing = RoutingState(
      current: _routing?.current,
      previous: _routing?.previous,
      args: _routing?.args,
      removed: _routing?.removed,
      route: _routing?.route,
      isBack: _routing?.isBack,
      isBottomSheet: _routing?.isBottomSheet,
      isDialog: _routing?.isDialog,
      isBackFromOverlay: isBackFromOverlay,
    );

    if (_routing == null) return;

    // validate if overlay is open
    if (!isOverlayOpened || (isOverlayOpened && (_routing.isBack ?? false))) {
      isOverlayOpened = (_routing.isDialog ?? false) ||
          (_routing.isBottomSheet ?? false) ||
          _routing.route is PopupRoute;
    }
  }
}
