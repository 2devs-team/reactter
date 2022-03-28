// ignore_for_file: non_constant_identifier_names

library reactter;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
import 'package:reactter/presentation/reactter_context.dart';
import 'package:reactter/utils/reactter_types.dart';
import 'package:reactter/core/reactter_interface.dart';

export 'package:reactter/utils/reactter_types.dart';
export 'package:reactter/presentation/reactter_use_effect.dart';
export 'package:reactter/core/reactter_routing_controller.dart';
export 'package:reactter/core/reactter_controller.dart';
export 'package:reactter/core/reactter_factory.dart';
export 'package:get/get.dart';
export 'package:get/get_state_manager/src/simple/get_widget_cache.dart';
export 'package:reactter/presentation/reactter_component.dart';
export 'package:reactter/presentation/reactter_context.dart';

class _ReactterInterface extends ReactterInterface {}

final Reactter = _ReactterInterface();

class ReactterHook with ReactterPubSub {}

class ReactterHookGestor extends ReactterHook {
  final Set<ReactterHook> _hooks = {};

  void listenHooks(List<ReactterHook> hooks) {
    for (final _hook in hooks) {
      if (_hooks.contains(_hook)) {
        return;
      }

      _hooks.add(_hook);

      _hook.subscribe(publish);
    }
  }
}

class UseEffect extends ReactterHookGestor {
  UseEffect(
    void Function() callback,
    List<ReactterHook> dependencies, [
    ReactterHookGestor? context,
  ]) {
    subscribe(callback);
    listenHooks(dependencies);
    context?.listenHooks([this]);
  }
}

class UseState<T> extends ReactterHook {
  UseState(
    this.initial, {
    this.alwaysUpdate = false,
    UpdateCallback<T>? willUpdate,
    UpdateCallback<T>? didUpdate,
    ReactterHookGestor? context,
  })  : _willUpdate = willUpdate,
        _didUpdate = didUpdate {
    context?.listenHooks([this]);
  }

  T initial;
  final bool alwaysUpdate;
  final UpdateCallback<T>? _didUpdate;
  final UpdateCallback<T>? _willUpdate;
  final List<UpdateCallback<T>> _didUpdateList = [];
  final List<UpdateCallback<T>> _willUpdateList = [];

  late T _value = initial;
  T get value => _value;
  set value(T value) {
    if (value != _value || alwaysUpdate || value.hashCode != _value.hashCode) {
      final oldValue = _value;

      _onWillUpdate(oldValue, value);

      _value = value;

      update();

      _onDidUpdate(oldValue, value);

      publish();
    }
  }

  void Function() willUpdate(UpdateCallback<T> listener) {
    _willUpdateList.add(listener);
    return () => _willUpdateList.remove(listener);
  }

  void Function() didUpdate(UpdateCallback<T> listener) {
    _didUpdateList.add(listener);
    return () => _didUpdateList.remove(listener);
  }

  void reset() {
    value = initial;
  }

  void update() {
    // _update?.call([key]);
  }

  void _onWillUpdate(T oldValue, T value) {
    _willUpdate?.call(oldValue, value);

    for (final listener in _willUpdateList) {
      listener(oldValue, value);
    }
  }

  void _onDidUpdate(T oldValue, T value) {
    _didUpdate?.call(oldValue, value);

    for (final listener in _didUpdateList) {
      listener(oldValue, value);
    }
  }
}

/// This is a wrapper of GetView widget
/// GetView is a great way of quickly access your Controller
/// without having to call Get.find<AwesomeController>() yourself.
///
/// Sample:
/// ```
/// class AwesomeController extends GetxController {
///   final String title = 'My Awesome View';
/// }
///
/// class AwesomeView extends GetView<AwesomeController> {
///   /// if you need you can pass the tag for
///   /// Get.find<AwesomeController>(tag:"myTag");
///   @override
///   final String tag = "myTag";
///
///   AwesomeView({Key key}):super(key:key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       padding: EdgeInsets.all(20),
///       child: Text( controller.title ),
///     );
///   }
/// }
///``
///
///
abstract class ReactterView<T> extends StatelessWidget {
  const ReactterView({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context);
}

/// GetWidget is a great way of quickly access your individual Controller
/// without having to call Get.find<AwesomeController>() yourself.
/// Get save you controller on cache, so, you can to use Get.create() safely
/// GetWidget is perfect to multiples instance of a same controller. Each
/// GetWidget will have your own controller, and will be call events as `onInit`
/// and `onClose` when the controller get in/get out on memory.
abstract class GetWidget<S extends GetLifeCycleBase?> extends GetWidgetCache {
  const GetWidget({Key? key}) : super(key: key);

  @protected
  final String? tag = null;

  S get controller => GetWidget._cache[this] as S;

  // static final _cache = <GetWidget, GetLifeCycleBase>{};

  static final _cache = Expando<GetLifeCycleBase>();

  @protected
  Widget build(BuildContext context);

  @override
  WidgetCache createWidgetCache() => _GetCache<S>();
}

class _GetCache<S extends GetLifeCycleBase?> extends WidgetCache<GetWidget<S>> {
  S? _controller;
  bool _isCreator = false;
  InstanceInfo? info;
  @override
  void onInit() {
    info = GetInstance().getInstanceInfo<S>(tag: widget!.tag);

    _isCreator = info!.isPrepared && info!.isCreate;

    if (info!.isRegistered) {
      _controller = Get.find<S>(tag: widget!.tag);
    }

    GetWidget._cache[widget!] = _controller;
    super.onInit();
  }

  @override
  void onClose() {
    if (_isCreator) {
      Get.asap(() {
        widget!.controller!.onDelete();
        Get.log('"${widget!.controller.runtimeType}" onClose() called');
        Get.log('"${widget!.controller.runtimeType}" deleted from memory');
        GetWidget._cache[widget!] = null;
      });
    }
    info = null;
    super.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return widget!.build(context);
  }
}
