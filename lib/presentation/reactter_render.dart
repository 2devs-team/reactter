library reactter;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:reactter/core/reactter_factory.dart';

class Render<T extends GetxController> extends GetBuilder<T> {
  const Render({
    Key? key,
    required final GetControllerBuilder<T> builder,
    final bool global = true,
    final Object? id,
    final String? tag,
    final bool autoRemove = true,
    final bool assignId = false,
    final Object Function(T value)? filter,
    final void Function(GetBuilderState<T> state)? initState,
    dispose,
    didChangeDependencies,
    final void Function(GetBuilder oldWidget, GetBuilderState<T> state)?
        didUpdateWidget,
    final T? init,
  }) : super(
          key: key,
          init: init,
          global: global,
          builder: builder,
          autoRemove: autoRemove,
          assignId: assignId,
          initState: initState,
          filter: filter,
          tag: tag,
          dispose: dispose,
          id: id,
          didChangeDependencies: didChangeDependencies,
          didUpdateWidget: didUpdateWidget,
        );
  @override
  RenderState<T> createState() => RenderState<T>();
}

class RenderState<T extends GetxController> extends GetBuilderState<T> {
  List<VoidCallback?>? _removes;
  Object? _filter;
  bool? _isCreator = false;

  @override
  void initState() {
    // _GetBuilderState._currentState = this;
    super.initState();
    widget.initState?.call(this);

    var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    final isReactterRegister = ReactterFactory().isRegistered<T>();

    if (widget.global) {
      if (isRegistered) {
        if (GetInstance().isPrepared<T>(tag: widget.tag)) {
          _isCreator = true;
        } else {
          _isCreator = false;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
      } else {
        controller = widget.init;
        _isCreator = true;
        GetInstance()
            .lazyPut<T>(() => controller!, tag: widget.tag, fenix: true);
        GetInstance().put<T>(controller!, tag: widget.tag);
      }
    } else {
      controller = widget.init;
      _isCreator = true;
      controller?.onStart();
    }

    if (widget.filter != null) {
      _filter = widget.filter!(controller!);
    }

    _subscribeToController();
  }

  @override
  void dispose() {
    _filter = null;
    _removeAll();
    super.dispose();
  }

  @override
  void didUpdateWidget(GetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    _removeAll();
    if (widget.id != null && widget.id is List) {
      for (var _id in (widget.id as List)) {
        final _remove = controller?.addListenerId(_id, () {
          _filter != null ? _filterUpdate() : getUpdate();
        });
        _removes?.add(_remove);
      }
    }
  }

  void _filterUpdate() {
    var newFilter = widget.filter!(controller!);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  void _removeAll() {
    _removes?.forEach((_remove) => _remove?.call());
    _removes = [];
  }
}
